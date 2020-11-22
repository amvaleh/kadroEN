class Api::V1::AuthenticationController < ApiController
  skip_before_action :authenticate_token
  include Swagger::Docs::Methods


  swagger_controller :authentication, "Authentication"



  swagger_api :create do |api|
    summary "Authentication User & Photographer"
    Api::V1::AuthenticationController::add_common_params(api)
    response :accepted
    response :unauthorized
  end

  def self.add_common_params(api)
    api.param :form, "user[mobile_number]", :string, :require, "Mobile Number Of User"
    api.param :form, "user[email]", :string, :require, "Email Of User"
    api.param :form, "photographer[mobile_number]", :string, :require, "Mobile Number Of Photographer"
    api.param :form, "photographer[password]", :string, :require, "Password Of Photographer"
  end

  def create
    if params[:photographer].present?

      if (photographer=Photographer.find_by_mobile_number(params[:photographer][:mobile_number])).present?
        if photographer.valid_password?(params[:photographer][:password])
          render json:{token:encode({type:1,user:photographer.id}),photographer_id: photographer.slug},status: :accepted #note type 1 => photographer
          return
        end
      end
      render json:{errors:["شماره تماس و یا ایمیل ورودی اشتباه است"]},status: :unauthorized

    elsif params[:user].present?
      if (user=User.find_by(mobile_number:params[:user][:mobile_number],email:params[:user][:email])).present?
        render json:{token:encode({type:2,user:user.id})},status: :accepted #note type 2 => user
      else
        render json:{errors:["شماره تماس و یا ایمیل ورودی اشتباه است"]},status: :unauthorized
      end

    end
  end

end
