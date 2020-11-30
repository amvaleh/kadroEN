class Project < ApplicationRecord
  include PublicActivity::Model
  visitable :ahoy_visit

  extend FriendlyId

  friendly_id :generate_token, use: :slugged

  attr_accessor :current_admin_user

  belongs_to :admin_user
  belongs_to :address
  belongs_to :receipt
  belongs_to :user
  belongs_to :coupon
  belongs_to :package
  belongs_to :shoot_type
  belongs_to :photographer
  belongs_to :week_day
  belongs_to :start_hour
  belongs_to :feedback_channel
  belongs_to :business
  belongs_to :reserve_step
  belongs_to :call_status
  belongs_to :lead_source
  has_one :gallery
  has_one :feed_back
  has_one :user_feedback
  has_many :sent_project_emails
  has_many :shoot_suggestions
  has_many :photographer_payments
  has_many :project_candidates
  has_many :cart_items
  has_many :credit_details
  belongs_to :visit, class_name: "Ahoy::Visit", foreign_key: :ahoy_visit_id

  after_update :update_gallery_limits
  after_update :take_action_by_step
  after_update :set_send_customer_at
  after_create :set_rate_reminder_sent
  after_update :log_activity
  before_create :check_other_project_lead_source
  after_update :set_other_project_lead_source
  before_save :check_payment_by_credit
  after_save :check_photographer_referral
  before_create :set_project_lead_source
  before_save :check_is_payed_for_fill_is_payed_at
  before_save :return_transportation_cost_to_user

  def return_transportation_cost_to_user
    if self.confirmed_changed? and self.confirmed == true and self.start_time.present? and self.start_time <= "2020-12-05" and self[:created_at] >= "2020-11-21"
      type = CreditDetailType.find_by(english_name: "return_transportion_cost")
      credit_detail = CreditDetail.find_by(project_id: self.id, credit_id: self.user.credit.id, value: self.receipt.transportion_cost.to_i, credit_detail_type_id: type.id)
      unless credit_detail.present?
        credit_detail = CreditDetail.new(project_id: self.id, credit_id: self.user.credit.id, value: self.receipt.transportion_cost.to_i, credit_detail_type_id: type.id)
        credit_detail.save
      end
    end
  end

  def check_is_payed_for_fill_is_payed_at
    if self.is_payed_changed? and self.is_payed == true
      self.is_payed_at = Time.now
    end
  end

  def set_other_project_lead_source
    if self.lead_source_id_changed?
      window = Setting.find_by(var: "project_lead_source_window").value
      projects = self.user.projects.where(created_at: Time.now - window.to_i.day..Time.now + window.to_i.day).update_all(lead_source_id: self.lead_source_id)
      if !self.user.lead_source.present?
        user = self.user
        user.lead_source_id = self.lead_source_id
        user.save
      end
    end
  end

  def set_project_lead_source
    if !self.lead_source.present? and self.user.lead_source.present?
      if self[:created_at] < (self.user[:created_at] + 3.weeks)
        self.lead_source_id = self.user.lead_source_id
      end
    end
  end

  def check_photographer_referral
    if self.reserve_step_id_changed?
      if self.reserve_step.name == "happy_call"
        if self.photographer.parent.present?
          count = Project.where(reserve_step_id: [16, 17], photographer_id: self.photographer.id).count
          if count <= 1
            sms_message = <<-text
واجد شرایط دریافت هدیه معرفی
عکاس معرفی شده: #{self.photographer.display_name}
              text
            SmsWorker.perform_async(sms_message, "09206152175")
            SmsWorker.perform_async(sms_message, "09123035856")
            SmsWorker.perform_async(sms_message, "09353954916")
            SmsWorker.perform_async(sms_message, "09126474907")
          end
        end
      end
    end
  end

  def check_other_project_lead_source
    window = Setting.find_by(var: "project_lead_source_window").value
    projects = self.user.projects.where(created_at: Time.now - window.to_i.day..Time.now)
    projects.each do |p|
      if p.lead_source.present?
        @lead_source = p.lead_source
      end
    end
    if @lead_source.present?
      self.lead_source = @lead_source
    end
  end

  def log_activity
    if self.current_admin_user.present?
      self.create_activity key: "admin_update", owner: AdminUser.find(self.current_admin_user), recipient_type: self.changes.except(:updated_at)
    end
  end

  def set_rate_reminder_sent
    self.rate_reminder_sent = false if self.rate_reminder_sent.nil?
    self.save
  end

  def set_send_customer_at
    if self.send_customer_changed?
      if self.send_customer
        Project.find(self.id).update_attributes(send_customer_at: Time.now)
      end
    elsif self.reserve_step_id_changed?
      if self.send_customer_at.nil? and self.send_customer
        Project.find(self.id).update_attributes(send_customer_at: Time.now)
      end
    end
  end

  def check_payment_by_credit
    if self.payment_by_credit_changed?
      if self.payment_by_credit == true
        if not self.photographer_payments.any?
          # this project doesnt have any photographer payments. so let's create some.
          project = self
          receipt = project.receipt
          if project.user.credit.value >= receipt.subtotal.to_f
            credit_detail = CreditDetail.new(value: -(receipt.subtotal.to_f), credit_id: project.user.credit.id, project_id: project.id, credit_detail_type_id: 2)
            credit_detail.save
            ph_payment = receipt.calculate_ph_payment(project.package.price.to_i, project.package.photographer_commission, receipt.impression_discount_package_for_city)
            Projects::CalculateBusinessShare.call(project: project)
            result = PhotographerPayments::PhotographerPaymentCreate.call(data: { photographer_id: project.photographer_id,
                                                                                  project_id: project.id,
                                                                                  price: ph_payment,
                                                                                  status: 2,
                                                                                  payment_type: 1 })
            if receipt.transportion_cost > 0
              transportion_cost_result = PhotographerPayments::PhotographerPaymentCreate.call(data: { photographer_id: project.photographer_id,
                                                                                                      project_id: project.id,
                                                                                                      price: receipt.transportion_cost,
                                                                                                      status: 2,
                                                                                                      payment_type: 4 })
            end
            project.is_payed = true
            project.reserve_step_id = ReserveStep.find_by(name: "wating_for_ph").id
            project.save
            # create transaction record here
            description = "پروژه پرداخت از اعتبار #{project.shoot_type.title} با #{project.photographer.display_name}"
            url = "/projects/#{project.slug}/thank_you"
            # transaction = Transactions::TransactionCreate.call(data: { email: project.user.email, description: description, amount: receipt.subtotal, afterwards_url: url , mobile_number: project.user.mobile_number, slug: "card_to_card"})
            #
            short_url = Shortener::ShortenedUrl.generate(url)
            if result.success?
              sms_message = <<-text
سفارش عکاسی شما ثبت گردید.
جزئیات برای عکاس انتخابی تان ارسال شد.
وضعیت پروژه: در انتظار بررسی عکاس
http://l.kadro.me/#{short_url.unique_key}
کادرو
              text
              SmsWorker.perform_async(sms_message, project.user.mobile_number)
              sms_message = <<-text
#{project.shoot_type.title}-#{project.receipt.subtotal}-#{project.photographer.projects.confirmed.count}
اعتباری
              text
              SmsWorker.perform_async(sms_message, "09206152175")
              SmsWorker.perform_async(sms_message, "09123035856")
              SmsWorker.perform_async(sms_message, "09353954916")
              SmsWorker.perform_async(sms_message, "09024608026")
              SmsWorker.perform_async(sms_message, "09123807488")
            end
          else
            self.payment_by_credit = false
          end
        end
      end
    end
  end

  def take_action_by_step

    # byebug
    # card to card
    if self.card_to_card_changed?
      if self.card_to_card == true
        if not self.photographer_payments.any?
          # this project doesnt have any photographer payments. so let's create some.
          project = self
          receipt = project.receipt
          ph_payment = receipt.calculate_ph_payment(project.package.price.to_i, project.package.photographer_commission, receipt.impression_discount_package_for_city)
          Projects::CalculateBusinessShare.call(project: project)
          result = PhotographerPayments::PhotographerPaymentCreate.call(data: { photographer_id: project.photographer_id,
                                                                                project_id: project.id,
                                                                                price: ph_payment,
                                                                                status: 2,
                                                                                payment_type: 1 })
          if receipt.transportion_cost > 0
            transportion_cost_result = PhotographerPayments::PhotographerPaymentCreate.call(data: { photographer_id: project.photographer_id,
                                                                                                    project_id: project.id,
                                                                                                    price: receipt.transportion_cost,
                                                                                                    status: 2,
                                                                                                    payment_type: 4 })
          end
          project.is_payed = true
          project.reserve_step_id = ReserveStep.find_by(name: "wating_for_ph").id
          project.save
          # create transaction record here
          description = "پروژه کارت به کارتی #{project.shoot_type.title} با #{project.photographer.display_name}"
          url = "/projects/#{project.slug}/thank_you"
          # transaction = Transactions::TransactionCreate.call(data: { email: project.user.email, description: description, amount: receipt.subtotal, afterwards_url: url , mobile_number: project.user.mobile_number, slug: "card_to_card"})
          #
          short_url = Shortener::ShortenedUrl.generate(url)
          if result.success?
            sms_message = <<-text
سفارش عکاسی شما ثبت گردید.
جزئیات برای عکاس انتخابی تان ارسال شد.
وضعیت پروژه: در انتظار بررسی عکاس
http://l.kadro.me/#{short_url.unique_key}
کادرو
            text
            SmsWorker.perform_async(sms_message, project.user.mobile_number)
            sms_message = <<-text
#{project.shoot_type.title}-#{project.receipt.subtotal}-#{project.photographer.projects.confirmed.count}
کارتی
            text
            SmsWorker.perform_async(sms_message, "09206152175")
            SmsWorker.perform_async(sms_message, "09123035856")
            SmsWorker.perform_async(sms_message, "09353954916")
            SmsWorker.perform_async(sms_message, "09024608026")
            SmsWorker.perform_async(sms_message, "09123807488")
          end
        end
      else
      end
    end
    # reserve_steps

    if self.reserve_step_id_changed?
      #confirmed
      if self.reserve_step.name == "confirmed" or self.reserve_step.name == "change_time"
        self.project_candidates.where(:project_candidate_status_id => ProjectCandidateStatus.find_by(title: "accepted").id).update_all(:project_candidate_status_id => ProjectCandidateStatus.find_by(title: "waiting").id)
        self.project_candidates.find_by(photographer_id: self.photographer_id).update(:project_candidate_status_id => ProjectCandidateStatus.find_by(title: "accepted").id)

        if self.user.email.present? and Rails.env.production?
          self.send_info_email_to_customer
        end
        if self.reserve_step.name == "confirmed" and Rails.env.production?
          self.send_info_sms_to_customer(self)
        end
      end

      # wating_for_ph
      if self.reserve_step.name == "wating_for_ph"
        self.update_column(:confirmed, false)
        # update project candidates if this ph is in candidats
        self.project_candidates.where(:project_candidate_status_id => ProjectCandidateStatus.find_by(title: "waiting").id).update_all(:project_candidate_status_id => ProjectCandidateStatus.find_by(title: "rejected").id)
        if self.project_candidates.find_by(photographer_id: self.photographer.id).present?
          self.project_candidates.find_by(photographer_id: self.photographer.id).update(:project_candidate_status_id => ProjectCandidateStatus.find_by(title: "waiting").id)
        else # else add this ph
          result = ProjectCandidates::ProjectCandidateCreateForKnownPhotographer.call(data: self.photographer, project: self)
        end
        if Rails.env.production?
          self.send_info_sms_to_ph
          self.send_info_email_to_ph
        end
      end
      if self.reserve_step.name == "re_edit"
        # tell ph to edit photos
      end
      if self.reserve_step.name == "qualified"
        #  tell customer to see gallery
        self.send_gallery_to_customer
        self.update_column(:has_gallery, true)
        self.update_column(:send_customer, true)
        unless self.qualified_at.present?
          self.update_column(:qualified_at, Time.now)
        end
        # add email to customer here
      end
      if self.reserve_step.name == "checkout"
        self.update_column(:checked_out, true)
      end
      if self.reserve_step.name == "canseled_project"
        result = Projects::SendCanceledProjectMessageToPhotographer.call(project_id: self.id)
        credit_detail = CreditDetail.new(value: self.receipt.subtotal, project_id: self.id, credit_id: self.user.credit.id, credit_detail_type_id: 7)
        credit_detail.save
      end
      if self.reserve_step.name == "happy_call"
        result = Projects::SendDontCheetOverUsPlease.call(project_id: self.id)
      end
    end
  end

  def tell_customer
    if self.send_customer_changed?
      if self.send_customer
        if self.gallery.present?
          short_url = Shortener::ShortenedUrl.generate("/galleries/#{self.gallery.slug}")

          sms_message = <<-text
#{self.user.display_name} عزیز، عکس های شما حاضر شده است، از طریق لینک زیر می تونید آنها را مشاهده، دانلود و به اشتراک بگذارید:
http://l.kadro.me/#{short_url.unique_key}
با امتیاز دهی به عکاس ما را در افزایش کیفیت خدمات یاری کنید.
          کادرو
          text
          SmsWorker.perform_async(sms_message, self.user.mobile_number)
        end
      end
    end
  end

  def update_gallery_limits
    if self.package_id_changed? and self.gallery.present?
      gallery = self.gallery
      case self.package.is_full
      when true
        gallery.download_limit = 0
      when false
        gallery.download_limit = self.package.digitals
      end
      gallery.save
    end
  end

  def check_confirmation
    if self.confirmed
      self.send_info_email_to_ph
      self.send_info_sms_to_ph
      self.send_info_sms_to_customer(self)
    end
  end

  def generate_token
    loop do
      random_token = SecureRandom.urlsafe_base64(5, false)
      break random_token unless Project.exists?(slug: random_token)
    end
  end

  def send_info_email_to_ph
    EmailPhotographerNewProject.perform_async(self.slug)
  end

  def send_info_email_to_customer
    EmailProjectSubmitted.perform_async(self.slug)
  end

  def send_info_sms_to_ph
    result = Projects::SendInformationToPhotographer.call(project_id: self.id)
    return result.res
  end

  def send_info_sms_to_customer(project)
    short_url = Shortener::ShortenedUrl.generate("/projects/#{project.slug}/thank_you")

    sms_message = <<-text
    پروژه شما تایید گردید:
    http://l.kadro.me/#{short_url.unique_key}
    شماره موبایل عکاس:
    #{project.photographer.first_name + " " + project.photographer.last_name + " "}
    #{project.photographer.mobile_number}
    - عکسهایتان که آماده شود پیامکی از کادرو دریافت می کنید.
    - در قسمت آلبوم من می توانید عکسها را ببینید، نمره دهید و پرداخت امن را برای عکاس آزاد کنید:
    http://bit.ly/32CYQQG
    text
    res = SmsWorker.perform_async(sms_message, self.user.mobile_number)
    return res
  end

  def send_gallery_to_customer
    if self.gallery.present?
      short_url = Shortener::ShortenedUrl.generate("/galleries/#{self.gallery.slug}")

      sms_message = <<-text
#{self.user.display_name} عزیز، عکس های شما حاضر شده است، از طریق لینک زیر می توانید آنها را مشاهده و دانلود کنید و به اشتراک بگذارید:
      http://l.kadro.me/#{short_url.unique_key}
با امتیاز دهی به عکاس  خود، ما را در افزایش کیفیت خدمات یاری کنید.
- برای امتیاز دهی و آزادسازی مبلغ عکاس در صورت رضایت، از قسمت آلبوم من اقدام فرمایید.
      text
      SmsWorker.perform_async(sms_message, self.user.mobile_number)
      if self.user.email.present?
        SendGalleryLinkWorker.perform_async(self.id)
      end
    end
  end

  def set_reserve_step(step)
    p = self
    p.reserve_step_id = ReserveStep.find_by_name(step).id
  end

  def profit_for_kadro
    p = self
    # package
    package = p.package.price.to_i
    total = package
    if p.coupon.present?
      puts "has coupon"
      if p.coupon.is_percent
        puts "is percent"

        total = package - ((p.coupon.value / 100) * package)
      else
        puts "is static"

        total = package - p.coupon.value
      end
    end
    # photographer commision from package
    puts "after copoun:" + total.to_s
    total = total - ((package * p.package.photographer_commission) / 100)
    puts "after ph commission:" + total.to_s

    # extend
    total = total + (p.receipt.extrahour_total * 0.3)
    puts "after extra hour total:" + total.to_s
    # shop print
    # shop download
    Invoice.joins(:invoice_items => :cart_item).where(:cart_items => { :project_id => p.id }, :status => 1).distinct.each do |invo|
      t = Invoices::CurrentInvoiceTotal.call(invoice: invo, status: invo.status).invoice_total
      c = Invoices::CurrentInvoiceCost.call(invoice: invo, status: invo.status).invoice_total
      profit = t - c
      total = total + profit
    end
    puts "after shop costs:" + total.to_s

    cost = 0
    if p.photographer_payments.where(:payment_type => 3).any?
      p.photographer_payments.where(:payment_type => 3).each do |pp|
        cost = cost + pp.price.to_i
      end
    end
    total = total - cost
    puts "after ph shop costs:" + total.to_s
    return total
  end

  def payment_status
    case self.reserve_step.name
    when "happy_call"
      "آزاد شده"
    when "checkout"
      "آزاد شده"
    else
      "پرداخت امن کارفرما"
    end
  end

  scope :payed, -> {
          where(:is_payed => true)
        }

  scope :future, -> {
          where("start_date > ? ", Time.zone.now)
        }

  scope :past, -> {
          where("start_date < ? ", Time.zone.now)
        }

  scope :confirmed, -> {
          where(:confirmed => true)
        }
  scope :confirmed_with_date, ->(start_date, end_date) { where("is_payed_at >= ? and is_payed_at <= ? and confirmed = true", start_date.to_date.to_time, end_date.to_date.to_time) }

  scope :confirmed_with_date_and_lead_source, ->(start_date, end_date, lead_source_id) { where("is_payed_at >= ? and is_payed_at <= ? and confirmed = true and lead_source_id = ?", start_date.to_date.to_time, end_date.to_date.to_time, lead_source_id) }

  scope :confirmed_with_nil_lead_sources, ->(start_date, end_date) { where("is_payed_at >= ? and is_payed_at <= ? and confirmed = true", start_date.to_date.to_time, end_date.to_date.to_time) }

  scope :finished, -> {
          where(:confirmed => true, :is_payed => true)
        }

  scope :not_payed, -> {
          where(:is_payed => false)
        }

  scope :shooted, -> {
          where(:is_shooted => true)
        }

  scope :uploaded, -> {
          where(:is_uploaded => true)
        }

  scope :send_customer, -> {
          where(:send_customer => true)
        }

  scope :checked_out, -> {
          where(:checked_out => true)
        }

  scope :publishable, -> {
          where(:publishable => true)
        }

  scope :not_passed_72hour, -> {
          where(:passed_72hour => false)
        }

  scope :has_gallery, -> {
          where(:has_gallery => true)
        }

  scope :doesnt_have_gallery, -> {
          where.not(:id => Gallery.select(:project_id).uniq)
          # where(:has_gallery => true)
        }

  scope :delivery_at_location, -> {
          where(:delivery_at_location => true)
        }

  scope :has_reserve_step, -> {
          where.not(:reserve_step_id => nil)
        }

  scope :more_than_3days, -> {
          where("projects.start_time >= ?", (3.days.from_now.beginning_of_day))
        }
  scope :after_tomorrow, -> {
          where(:start_time => (2.days.from_now.beginning_of_day)..(3.days.from_now.beginning_of_day))
        }
  scope :tomorrow, -> {
          where(:start_time => (1.days.from_now.beginning_of_day)..(2.days.from_now.beginning_of_day))
        }
  scope :today, -> {
          where(:start_time => (Date.today.beginning_of_day)..(Date.today.end_of_day))
        }
  scope :_72_hour, -> {
          where(:start_time => (3.days.ago)..(Date.today.beginning_of_day))
        }
  scope :while_ago, -> {
          where(:start_time => (15.days.ago)..(Date.today.beginning_of_day))
        }

  scope :a_month_ago, -> {
          where(:start_time => (30.days.ago)..(Date.today.beginning_of_day))
        }

  scope :between_2_and_3_hour_ago, -> { posted_between_period(Time.now - 3.hour, Time.now - 2.hour) }

  scope :package_is_vip, -> { joins(:package).where("packages.vip = true") }

  scope :memory_plus, -> {
          where(:delivery_at_location => true)
        }
end
