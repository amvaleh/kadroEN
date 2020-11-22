class ProjectsController < ApplicationController
  include Devise::Controllers::ScopedViews
  before_action :authenticate_user!, except: [:receipt, :gracias, :project_information, :thank_you, :ph_approval, :extra_hour, :extra_receipt, :success_payment_notification, :verify_pay, :set_first_call, :not_answered, :sms_link_to_user]
  before_action :find_project, except: [:package]
  # before_action :authenticate_photographer!, only: [:project_information, :ph_approval]
  before_action :set_photographer, only: [:project_information, :ph_approval]
  before_action :authenticate_admin_user!, only: [:set_first_call, :not_answered]
  include ApplicationHelper
  include ReserveHelper

  def project_information
    @project.photographer.create_activity :ph_see_project_info, owner: current_photographer, recipient: @project
  end

  def package
    @user = current_user
    if params[:shoot_type_id].present? and params[:package_id].present? and params[:b].present?
      @only_info_needed = true
    end
  end

  def where_and_when
  end

  def photographer
    @photographers = available_photographer(@project.slug, @project.start_time)
  end

  def details
    # byebug
  end

  def receipt
    @title = "فاکتور عکاسی #{@project.shoot_type.title} با #{@project.photographer.abbrv_name} | کادرو "
    @favicon = @project.shoot_type.avatar_url(:large)
    @description = "فاکتور عکاسی #{@project.shoot_type.title} با #{@project.photographer.abbrv_name}. برای ثبت نهایی پروژه لطفا مبلغ #{@project.receipt.subtotal} را به صورت آنلاین یا کارت به کارت واریز فرمایید تا پروژه برای عکاس ارسال گردد. بعد از ثبت نهایی می توانید با عکاس تان تلفنی صحبت کنید."
  end

  def thank_you
    @title = "عکاسی #{@project.shoot_type.title} با #{@project.photographer.abbrv_name} | کادرو "
    @favicon = @project.shoot_type.avatar_url(:large)
    @description = "عکاسی #{@project.shoot_type.title} با #{@project.photographer.abbrv_name} در تاریخ #{convert_persian_day(@project.start_time.strftime("%A")).to_s + " " + @project.start_time.to_date.to_pdate.strftime("%e %b").to_s + " ساعت " + @project.start_time.strftime("%H:%M")} به مدت #{@project.package.duration}. با آرزوی ثبت بهترین لحظات برای شما"
  end

  def gracias
    if @project.one_time_visit_to_goal
      redirect_to thank_you_project_path(@project)
    else
      @project.one_time_visit_to_goal = true
      @project.save
    end
  end

  def extra_hour
  end

  def extra_receipt
    cost = 0

    cost = @project.shoot_type.half_hour_extend_cost * (@project.extra_hour_requested.to_f * 2)

    render locals: { cost: cost }
  end

  def verify_pay
    if params[:status] == "nok"
      redirect_to extra_receipt_project_path(@project),
                  alert: t(:'projects.messages.failed_pay')
    elsif params[:id] or params[:zero_payment]
      validation = Transactions::ValidateUpdate.call(trace_number: params[:track_code])
      if validation.success? or params[:zero_payment]
        receipt = @project.receipt
        if params[:track_code] or params[:zero_payment]
          # params[:track_code] = 1002 # should be commented
          amount = 0
          extrahour_total = 0
          if @project.extra_hour_requested.present? and @project.extra_hour_requested != 0
            extend_results = Projects::ExtraHourDetails.call(project: @project)
            amount = extend_results.amount
            ph_commission = extend_results.ph_commission
            extrahour_total = extend_results.extrahour_total
            new_frames = extend_results.new_frames
            if @project.gallery.present?
              gallery = @project.gallery
              gallery.download_limit = gallery.download_limit + new_frames
              gallery.save
            end
            # ph_commission=((Setting.find_by_var("photographer_extra_hour_commission").value.to_i).to_f/100)

            Projects::SuccessExtendSmsToPhotographer.call(hours_added: extend_results.hours_added, mobile_number: @project.photographer.mobile_number)
          end

          ActiveRecord::Base.transaction do
            Receipts::Update.call(id: receipt.id, data: { extrahour_track_code: params[:track_code],
                                                          extrahour_paid: receipt.extrahour_paid + amount.to_i,
                                                          total: (receipt.total.to_i + amount.to_i).to_s,
                                                          subtotal: (receipt.subtotal.to_i + amount.to_i).to_s,
                                                          ph_payment: (receipt.ph_payment.to_i + (amount.to_i * ph_commission)).to_i.to_s,
                                                          extra_paid: true,
                                                          extrahour_total: extrahour_total })
            result = PhotographerPayments::PhotographerPaymentCreate.call(data: { photographer_id: @project.photographer_id,
                                                                                  project_id: @project.id,
                                                                                  price: (amount.to_i * ph_commission).to_i,
                                                                                  status: 2,
                                                                                  payment_type: 2 })
            if result.success?
              if params[:credit] == "true" or params[:zero_payment]
                credit = current_user.credit
                usage = params[:zero_payment] ? params[:credit_usage].to_i : credit.value
                credit_detail_type = CreditDetailType.find_by(english_name: "use_in_extend_time")
                Credits::CheckCreditUsage.call(credit: credit, usage_amount: usage, credit_detail_type: credit_detail_type)
              end

              @project.user.create_activity :succeed_in_extra_payment, owner: @project.user, recipient: @project
              if params[:zero_payment]
                sms_message = "تمدید با موفقیت ثبت شد. کادرو"
              else
                sms_message = t(:'projects.messages.sms_message', ref_id: params[:track_code])
              end
              SmsWorker.perform_async(sms_message, @project.user.mobile_number)

              redirect_to thank_you_project_path(@project.slug),
                          notice: t(:'projects.messages.success_pay')
            else
              @error = "کد پیگیری تکراری است."
              raise ActiveRecord::Rollback
            end
          end
        else
          redirect_to extra_receipt_project_path(@project),
                      alert: t(:'projects.messages.failed_pay')
        end
      else
        @project.user.create_activity :not_succeed_in_extra_payment, owner: @project.user, recipient: @project
        @error = "تراکنش با خطا مواجه شد."
      end
    end
  end

  def ph_approval
    if params[:status].present?
      candidate = @project.project_candidates.find_by(:photographer => @project.photographer)
      if params[:status] == "true"
        # check to prevent sending duplicate sms s
        if not @project.confirmed and not @project.reserve_step_id == ReserveStep.find_by(name: "confirmed").id
          @project.set_reserve_step("confirmed")
          @project.confirmed = true
          @project.save
          candidate.project_candidate_status_id = ProjectCandidateStatus.find_by(:title => "accepted").id
          @project.photographer.create_activity :ph_approve_project, owner: @project.photographer, recipient: @project
          redirect_to project_information_project_path(@project), alert: "پروژه با موفقیت تائید شد."
        end
      elsif params[:status] == "false"
        if params[:reason_for_reject_id].present?
          Projects::CalculatePenaltyForCancel.call(project_id: @project.id, project_candidate_id: candidate.id, reason_for_reject_id: params[:reason_for_reject_id])
          Projects::RejectProject.call(project_id: @project.id, project_candidate_id: candidate.id, reason_for_reject_id: params[:reason_for_reject_id])
          @project.photographer.create_activity :ph_reject_project, owner: @project.photographer, recipient: @project
          redirect_to projects_photographer_path(@project.photographer), alert: "انصراف از پروژه ثبت گردید."
        end
      elsif params[:status] == "change_time"
        date = params[:new_date].to_date
        hour = params[:new_hour]
        min = params[:new_min]
        datetime = DateTime.new(date.year, date.month, date.day, hour.to_i, min.to_i, 0, Time.now.zone)
        old_time = convert_persian_day(@project.start_time.strftime("%A")).to_s + " " + @project.start_time.to_date.to_pdate.strftime("%e %b").to_s + " ساعت " + @project.start_time.strftime("%H:%M")
        @project.start_time = datetime
        @project.set_reserve_step("change_time")
        @project.confirmed = true
        @project.save
        candidate.project_candidate_status_id = ProjectCandidateStatus.find_by(:title => "accepted").id
        time = convert_persian_day(@project.start_time.strftime("%A")).to_s + " " + @project.start_time.to_date.to_pdate.strftime("%e %b").to_s + " ساعت " + @project.start_time.strftime("%H:%M")
        sms_message = <<-text
#{@project.user.display_name} عزیز،
 زمان پروژه عکاسی شما مورخ #{old_time} با موفقیت به تاریخ دیگری تغییر یافت.
زمان جدید:
#{time}
در صورتی که تغییری برای تاریخ عکاسی خود نداشته اید حتما این موضوع را با عکاس #{@project.photographer.display_name} بررسی کنید.
شماره عکاس:#{@project.photographer.mobile_number}
کادرو
        text
        SmsWorker.perform_async(sms_message, @project.user.mobile_number) if Rails.env.production?
        @project.photographer.create_activity :ph_change_time_project, owner: current_photographer, recipient: @project
        redirect_to project_information_project_path(@project), alert: "پروژه عکاسی ضمن تغییر زمان با موفقیت تایید شد."
      end
      candidate.save
    else
      redirect_to project_information_project_path(@project), alert: "خطا در ارسال اطلاعات، لطفا با پشتیبانی تماس بگیرید."
    end
  end

  def success_payment_notification
    if params[:status].present? and params[:status] == "nok"
      @project.set_reserve_step("canceled_payment")
      @project.is_payed = false
      @project.save
      redirect_to receipt_project_path(@project), alert: "#{params[:message]}. لطفا مجددا تلاش کنید."
    else
      validation = Transactions::ValidateUpdate.call(trace_number: params[:track_code])
      if validation.success? or params[:zero_payment]
        receipt = @project.receipt
        # TO DO: legacy, multiple ph payment codes
        ph_payment = receipt.calculate_ph_payment(@project.package.price.to_i, @project.package.photographer_commission, receipt.impression_discount_package_for_city)
        ActiveRecord::Base.transaction do
          Receipts::Update.call(id: @project.receipt.id, data: { track_code: params[:track_code], ph_payment: (ph_payment) })
          @project.is_payed = true
          @project.set_reserve_step("wating_for_ph")
          @project.save

          TransportationCost.create(value: receipt.transportion_cost, receipt_id: receipt.id, active: true, is_payed: true)

          Projects::CalculateBusinessShare.call(project: @project)
          result = PhotographerPayments::PhotographerPaymentCreate.call(data: { photographer_id: @project.photographer_id,
                                                                                project_id: @project.id,
                                                                                price: ph_payment,
                                                                                status: 2,
                                                                                payment_type: 1 })
          if receipt.transportion_cost > 0
            transportion_cost_result = PhotographerPayments::PhotographerPaymentCreate.call(data: { photographer_id: @project.photographer_id,
                                                                                                    project_id: @project.id,
                                                                                                    price: receipt.transportion_cost,
                                                                                                    status: 2,
                                                                                                    payment_type: 4 })
          end
          if result.success?
            if @project.package.extra_credit.present?
              if @project.package.extra_credit > 0 or @project.package.extra_credit < 0
                credit_detail_type = CreditDetailType.find_by(english_name: "auto_package_credit")
                credit = @project.user.credit
                credit_detail = CreditDetail.new(value: @project.package.extra_credit, project_id: @project.id, credit_id: credit.id, credit_detail_type_id: credit_detail_type.id)
                credit_detail.save
              end
            end
            if params[:credit] == "true" or params[:zero_payment]
              credit = current_user.credit
              usage = params[:zero_payment] ? params[:credit_usage].to_i : credit.value
              credit_detail_type = CreditDetailType.find_by(english_name: "use_in_package")
              Credits::CheckCreditUsage.call(credit: credit, usage_amount: usage, credit_detail_type: credit_detail_type)
            end

            if params[:free_credit] == "true"
              free_credit = Setting.find_by(var: "free_credit").value.to_i
              Refers::IncrementReferCredit.call(key: params[:key], free_credit: free_credit)
              Refers::NotifyReferedUser.call(key: params[:key], credit: free_credit)
            end

            coupon = receipt.coupon
            if coupon.present?
              coupon.used_times = coupon.used_times + 1
              coupon.save
            end

            unless params[:zero_payment]
              #               sms_message = <<-text
              # سفارش عکاسی شما دریافت شد.
              # کد پیگیری :‌ #{params[:track_code]}
              # جزئیات سفارش شما برای عکاس انتخابی تان ارسال شد.
              # وضعیت پروژه: در انتظار بررسی عکاس
              # کادرو
              #               text
              result = Messages::KavenegarSendTemplate.call(mobile_number: @project.user.mobile_number, token: params[:track_code], template: "success-package-payment")
            else
              #               sms_message = <<-text
              # سفارش عکاسی شما دریافت شد.
              # جزئیات سفارش شما برای عکاس انتخابی تان ارسال شد.
              # وضعیت پروژه: در انتظار بررسی عکاس
              # کادرو
              #               text
              result = Messages::KavenegarSendTemplate.call(mobile_number: @project.user.mobile_number, token: "کادرو", template: "success-package-zero-payment")
            end
            # SmsWorker.perform_async(sms_message, @project.user.mobile_number)
            sms_message = <<-text
#{@project.shoot_type.title}-#{@project.receipt.subtotal}-#{@project.photographer.projects.confirmed.count}
            text
            SmsWorker.perform_async(sms_message, "09206152175")
            SmsWorker.perform_async(sms_message, "09123035856")
            SmsWorker.perform_async(sms_message, "09353954916")
            SmsWorker.perform_async(sms_message, "09123807488")
            SmsWorker.perform_async(sms_message, "09024608026")
            @project.user.create_activity :succeed_in_payment, owner: @project.user, recipient: @project

            message = params[:zero_payment] ? "سفارش شما با موفقیت ثبت شد." : "تراکنش با موفقیت پرداخت شد. کد پیگیری: #{params[:track_code]}"

            Projects::TakhfifanAffiliate.call(project: @project)
            redirect_to gracias_project_path(@project), notice: message
          else
            @error = "کد پیگیری تکراری است."
            raise ActiveRecord::Rollback
          end
        end
      else
        @project.user.create_activity :not_succeed_in_payment, owner: @project.user, recipient: @project
        @error = "تراکنش با خطا مواجه شد"
      end
    end
  end

  def alternate_photographers
    @photographers = ProjectCandidates::ProjectAlternativeCandidates.call(project_id: @project.id).photographers
    unless @project.reserve_step.name == "care" or @project.reserve_step.name == "change_ph"
      redirect_to thank_you_project_path(@project.slug)
    end
  end

  def debit_check
    if params[:photographer_id].present?
      photographer = Photographer.find(params[:photographer_id])
      @project.photographer = photographer
      @project.save
      receipt = @project.receipt

      old_price = receipt.transportion_cost
      price = params[:price].to_f

      @user = @project.user

      credit = @user.credit
      if credit.nil?
        credit = Credit.create(owner: @user, value: 0)
      end

      difference = credit.value + old_price - price

      receipt.transportation_costs.update_all(active: false)
      TransportationCosts::TransportationCostCreate.call(data: { value: price,
                                                                 receipt_id: receipt.id,
                                                                 active: true })

      if difference >= 0
        ActiveRecord::Base.transaction do
          result = Projects::UpdateProjectPrices.call(project_id: @project.id, price: price, old_price: old_price)

          if result.success
            transportation_cost = receipt.transportation_costs.active[0]
            transportation_cost.is_payed = true
            transportation_cost.save

            credit.value = difference
            credit.save

            @project.create_activity :set_new_photographer, owner: @user, recipient: photographer

            redirect_to thank_you_project_path(@project.slug),
                        notice: "عکاس جدید با موفقیت ثبت شد."
          else
            @error = "عملیات با خطا مواجه شد"
            redirect_to alternate_photographers_project_path(@project.slug), alert: @error
            raise ActiveRecord::Rollback
          end
        end
      else
        @project.create_activity :bank_gateway_to_pay_negative_credit, owner: @user, recipient: photographer

        @project.set_reserve_step("change_ph")
        @project.save

        @old_price = old_price
        @difference = difference
        @price = price
      end
    end
  end

  def success_credit_settlement
    if params[:status].present? and params[:status] == "nok"
      redirect_to alternate_photographers_project_path(@project.slug), alert: "#{params[:message]}. لطفا مجددا تلاش کنید."
    else
      validation = Transactions::ValidateUpdate.call(trace_number: params[:track_code])
      if validation.success?
        old_price = @project.receipt.transportion_cost
        transportation_cost = @project.receipt.transportation_costs.active[0]
        price = transportation_cost.value

        ActiveRecord::Base.transaction do
          result = Projects::UpdateProjectPrices.call(project_id: @project.id, price: price, old_price: old_price)

          if result.success
            transportation_cost.is_payed = true
            transportation_cost.save

            credit = @project.user.credit
            credit.value = 0
            credit.save

            @project.create_activity :set_new_photographer, owner: @project.user, recipient: @project.photographer

            redirect_to thank_you_project_path(@project.slug),
                        notice: "عکاس جدید با موفقیت ثبت شد."
          else
            @error = "تراکنش با خطا مواجه شد"
            redirect_to alternate_photographers_project_path(@project.slug), alert: @error
            raise ActiveRecord::Rollback
          end
        end
      else
        @project.user.create_activity :not_succeed_in_payment, owner: @project.user, recipient: @project
        @error = "تراکنش با خطا مواجه شد"
        redirect_to alternate_photographers_project_path(@project.slug), alert: @error
      end
    end
  end

  def set_first_call
    if params[:first_call]
      unless @project.admin_user.present?
        if current_admin_user.present?
          @project.admin_user = current_admin_user
        end
      end
      @project.call_status_id = CallStatus.find_by(title: "called").id
      @project.save
    end
  end

  def not_answered
    short_url = Shortener::ShortenedUrl.generate("/projects/#{@project.slug}/receipt")
    unless @project.admin_user.present?
      if current_admin_user.present?
        @project.admin_user = current_admin_user
      end
    end
    if @project.reserve_step.name == "photographer" or @project.reserve_step.name == "details" or @project.reserve_step.name == "canceled_payment" and not @project.user.mobile_number == "09027993049"
      sms_message = <<-text
کادرو: تکمیل سفارش عکاسی #{@project.shoot_type.title}
#{@project.user.display_name} عزیز، سلام،
ما یک سفارش عکاسی ناتمام با #{@project.photographer.abbrv_name} از شما دریافت کردیم،
نگران نباشید، اطلاعات شما ذخیره شده است تا نیاز نباشد مجدد وارد کنید، فقط کافیست لینک زیر را لمس کنید و سفارش خود را تکمیل کنید:
http://l.kadro.co/#{short_url.unique_key}
تماس با ما:
02128425220
اینستاگرام ما:
http://bit.ly/2JpM8yZ
      text
    else
      sms_message = <<-text
کادرو: #{@project.user.display_name} عزیز، سلام،
یک سفارش عکاسی #{@project.shoot_type.title} از شما دریافت کردیم که تکمیل نشده است، در صورت نیاز به مشاوره تلفنی رایگان با ما تماس بگیرید. برای سفارش مجدد عکاسی از لینک زیر اقدام کنید:
#{Setting.find_by(var: "book_link").value}
تماس با ما:
02128425220
اینستاگرام ما:
http://bit.ly/2JpM8yZ
      text
    end
    SmsWorker.perform_async(sms_message, @project.user.mobile_number)
    @project.call_status_id = CallStatus.find_by(title: "not answered").id
    @project.save
  end

  def sms_link_to_user
    short_url = Shortener::ShortenedUrl.generate("/projects/#{@project.slug}/receipt")

    sms_message = <<-text
کادرو: #{@project.user.display_name} گرامی، با سلام،
جهت ثبت و تایید نهایی پروژه عکاسی خود، از طریق لینک زیر اقدام فرمایید.
http://l.kadro.co/#{short_url.unique_key}
پرداخت وجه به معنای قبول قوانین کادرو است.
با سپاس
    text
    SmsWorker.perform_async(sms_message, @project.user.mobile_number)
    @project.save
  end

  def release_payment
    project = @project
    # if project.reserve_step.name == "qualified" or project.reserve_step.name == "downloaded"
    project.set_reserve_step("happy_call")
    project.save
    # end

    if project.gallery.present?
      redirect_to gallery_path(project.gallery.slug), notice: "مبلغ پروژه با موفقیت برای عکاس آزاد شد، با تشکر از شما."
    else
      redirect_to galleries_url, notice: "مبلغ پروژه با موفقیت برای عکاس آزاد شد، با تشکر از شما."
    end
  end

  def set_delivery_at_location
    if @project.reserve_step_id > ReserveStep.find_by(name: "canceled_payment").id and @project.reserve_step_id < ReserveStep.find_by(name: "uploaded").id and @project.package.is_full
      @project.delivery_at_location = true
      @project.save
      Projects::TellPhDeliverAtLocation.call(photographer_name: @project.photographer.display_name, user_name: @project.user.display_name, mobile_number: @project.photographer.mobile_number)
      message = "درخواست شما با موفقیت ثبت شد. پس از پایان عکاسی، عکس ها را در محل از عکاس تحویل بگیرید."
      flash[:notice] = message
    else
      message = "درخواست شما با خطا مواجه شد."
      flash[:alert] = message
    end
    redirect_to thank_you_project_path
  end

  def find_project
    @project = Project.friendly.find(params[:id])
  end

  def set_photographer
    current_photographer = Project.friendly.find(params[:id]).photographer
  end
end
