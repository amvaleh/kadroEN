class Api::V1::PaymentsController < ApiController
  before_action :find_photographer, except: [:pay]
  before_action :find_project
  respond_to :json
  include Swagger::Docs::Methods

  swagger_controller :payments, "Payments"

  swagger_api :pay do |api|
    summary "Payment Zarinpal"
    Api::V1::PaymentsController::payments_pay_params(api)
    response :accepted
    response :unauthorized
  end

  def self.payments_pay_params(api)
    api.param :header, "Authorization", :string, :required, "Authorization"
    api.param :form, "description", :string, :require, "Description for Zarinpal"
    api.param :form, "email", :string, :required, "Email Of User"
    api.param :form, "mobile_number", :string, :required, "Mobile Number Of User"
    api.param :form, "amount", :string, :required, "Price"
    api.param :form, "project_slug", :string, :required, "Project Slug"
  end

  def pay
    description = params[:description]
    email = params[:email]
    mobile_number = params[:mobile_number]
    if Rails.env.production?
      call_back = "https://app.kadro.me/zarinpal/verify"
    elsif Rails.env.development?
      call_back = "http://app.localhost:3000/zarinpal/verify"
    elsif Rails.env.staging?
      call_back = "http://185.53.143.141:3005/zarinpal/verify"
    end
    if !params["amount"].blank?
      if params["amount"].to_i > 99
        client = Savon.client(
          wsdl: "https://de.zarinpal.com/pg/services/WebGate/wsdl",
        )
        response = client.call(:payment_request, message: {
                                                   "MerchantID" => "c4427bd0-348a-11e7-89d9-005056a205be", # ای پی آی درگاه زرین پال شما
                                                   "Amount" => params["amount"], # مبلغ پرداختی
                                                   "Description" => description,
                                                   "Email" => email,
                                                   "Mobile" => mobile_number,
                                                   "CallbackURL" => call_back, # صفحه بازگشت از درگاه
                                                 })
        results = response.body
        authority = results[:payment_request_response][:authority]
        status = results[:payment_request_response][:status]
        receipt = @project.receipt
        receipt.track_code = authority
        receipt.save
        if status.to_i < 100
          render :text => "Some Thing's wrrong"
        else
          session[:AMOUNT] = params["amount"] # ذخیره ی موقف مبلغ در سشن
          redirect_to "https://www.zarinpal.com/pg/StartPay/#{authority}/Sep"
        end
      else
        render json: { errors: ["مبلغ نا معتبر است"] }.to_json, status: :bad_request
      end
    else
      render json: { errors: ["مبلغ را وارد کنید"] }.to_json, status: :bad_request
    end
  end
end
