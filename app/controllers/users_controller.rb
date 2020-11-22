class UsersController < ApplicationController
  include Devise::Controllers::ScopedViews
  include UsersHelper
  include ApplicationHelper

  require "net/http"
  require "uri"
  require "json"
  respond_to :js

  before_action :authenticate_user!, only: [:refer, :refer_dashboard, :set_birthday_date, :update]

  before_action :verify_user, only: :check_number
  layout :resolve_layout

  def update
    @user = current_user
    @user.full_name = params[:full_name]
    @user.email = params[:email]
    @user.company_name = params[:company_name]
    respond_to do |format|
      if @user.save
        format.js
      end
    end
  end

  def set_birthday_date
    current_user.birthday_date = PDate.new(params[:year].to_i, params[:month].to_i, params[:day].to_i).to_date
    current_user.save
    credit_gift = 9999
    credit = current_user.credit
    credit.value = credit.value + credit_gift
    credit.save
    redirect_to galleries_path, notice: "تبریک، مبلغ #{credit_gift} تومان به اعتبار شما به عنوان هدیه افزوده گردید."
  end

  def register
    # byebug
    # if user_signed_in?
    #   if params[:b].present?
    #     byebug
    #     # having the business in url
    #     redirect_to business_projects_path(params[:b],request.params)
    #   else
    #     redirect_to package_projects_path(request.params)
    #   end
    # end
  end

  def set_call_date
    if params[:date].present? && params[:project_id]
      user = Project.find(params[:project_id]).user
      date = params[:date].tr!("/۰۱۲۳۴۵۶۷۸۹", "-0123456789")
      user.call_date = date.to_pdate.to_date
      user.is_called = false
      user.projects.update_all(call_status_id: CallStatus.find_by(title: "called"))
      user.save
    end
  end

  def is_called
    if params[:id].present?
      user = User.find(params[:id])
      user.is_called = true
      user.save
    end
  end

  def check_number
    if params[:mobile_number].present?
      mobile_number = params[:mobile_number]
    else
      mobile_number = params[:user][:mobile_number]
    end
    if mobile_number == "09031931470" || mobile_number == "09356965754" || mobile_number == "09123035856" ||
       mobile_number == "09353954916" || mobile_number == "09122087522" || mobile_number == "09027993049" ||
       mobile_number == "09120132331" || mobile_number == "09370027366" || mobile_number == "09136183194" ||
       mobile_number == "09121111111" || mobile_number == "09206152175" || mobile_number == "09121111111" || mobile_number == "09125239118" || mobile_number == "09101002002" || mobile_number == "09122173940"
      generated_password = "123456"
      indoor = true
      # snappfood users:
      # elsif mobile_number == '09112165263'
      #   generated_password = "ha123456"
      #   indoor = true
      # elsif mobile_number == '09359369369'
      #   generated_password = "1234567"
      #   indoor = true
    end
    @user = User.find_by_mobile_number(mobile_number)
    if @user.present?
      if @user.password_sent_times < 2
        if !indoor
          generated_password = rand.to_s[3..6]
        end
        @user.password = generated_password
        @user.password_confirmation = generated_password
        @user.reset_password_token = generated_password
        @user.password_sent_at = Time.now
        @user.password_sent_times = @user.password_sent_times + 1
      elsif (Time.now - @user.password_sent_at) > 1.minutes
        @user.password_sent_times = 1
        if !indoor
          generated_password = rand.to_s[3..6]
        end
        @user.password = generated_password
        @user.password_confirmation = generated_password
        @user.reset_password_token = generated_password
        @user.password_sent_at = Time.now
      else
        error = "error"
        # redirect_to users_register_path , alert: "تعدادی پیامک شامل کد تایید برای شما ارسال شده است. لطفا ۱۰ دقیقه دیگر منتظر بمانید."
      end
      unless @user.credit.present?
        @user.create_user_credit
      end
    else
      generated_password = rand.to_s[3..6]
      @user = User.new
      @user.mobile_number = mobile_number
      @user.password = generated_password
      @user.password_confirmation = generated_password
      @user.reset_password_token = generated_password
      @user.password_sent_times = @user.password_sent_times + 1
      @user.password_sent_at = Time.now
      if params[:business_name].present?
        @user.business = Business.find_by_name(params[:business_name])
      end
      # if session[:business].present?
      #   @user.business = Business.find_by_name(params[:business_name])
      #   session[:business] = nil
      # end
    end
    puts @user.password_sent_times
    puts @user.password_sent_at
    puts "pass"
    puts generated_password
    if error == "error"
      redirect_to new_user_session_path(mobile_number: @user.mobile_number), alert: "تعدادی پیامک شامل کد تایید برای شما ارسال شده است. لطفا ۳ دقیقه دیگر منتظر بمانید."
    elsif @user.save
      if @user.business.present?
        redirect_to new_user_session_path(mobile_number: @user.mobile_number,
                                          business_name: params[:business_name],
                                          package_id: params[:package_id],
                                          price: params[:price],
                                          shoot_type_id: params[:shoot_type_id],
                                          photographer_id: params[:photographer_id]), notice: "رمز یکبار مصرف برای شما پیامک شد."
      else
        redirect_to new_user_session_path(mobile_number: @user.mobile_number), notice: "رمز یکبار مصرف برای شما پیامک شد."
      end
      #       sms_message = <<-text
      # رمز موقت شما:
      # #{generated_password}
      # کادرو
      #       text
      if !indoor and Rails.env.production?
        # SmsWorker.perform_async(sms_message, @user.mobile_number)
        result = Messages::KavenegarSendTemplate.call(mobile_number: @user.mobile_number, token: generated_password, template: "user-password")
      end
    else
      render "users/register"
    end
  end

  def check_number_again
    user = Users::UserBySlug.call(slug: params[:slug]).result
    result = Users::CheckNumber.call(mobile_number: user.mobile_number)
    @message = if result.success?
        t(:'users.password_sent')
      else
        @error = "1"
        result.message
      end
  end

  def update_info
    if params[:user_id]
      user = User.find(params[:user_id])
      if user.present?
        user.email = params[:email]
        user.company_name = params[:company_name]
        user.save
        user.create_activity :entered_his_email, owner: user
      end
    end
  end

  def refer
    @user = current_user
  end

  def refer_dashboard
    @user = current_user
  end

  private

  def verify_user
    puts session[:tries]
    if session[:tries].present?
      date = session[:tries]["date"]
      if Time.now.to_date - date.sub!("T", " ").sub!(".", " ").to_date > 30.minutes
        session[:tries] = nil
      end
    end

    if session[:tries].present?
      session[:tries] = { value: session[:tries]["value"].to_i + 1, date: Time.now }
    else
      session[:tries] = { value: 1, date: Time.now }
    end

    if session[:tries][:value].to_i < 5
      true
    else
      redirect_to new_user_session_path(mobile_number: params[:mobile_number]), alert: "پیامک برای شما ارسال شده است."
    end
  end

  def users_params
    params.require(:user).permit(:first_name, :last_name, :mobile_number, :company_name)
  end

  def resolve_layout
    case action_name
    when "refer_dashboard"
      "dashboard"
    else
      "application"
    end
  end
end
