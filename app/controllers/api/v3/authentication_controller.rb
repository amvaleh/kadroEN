class Api::V3::AuthenticationController < ApiController
  skip_before_action :authenticate_token

  def create
    if params[:photographer].present?
      if (photographer = Photographer.find_by_mobile_number(params[:photographer][:mobile_number])).present?
        if photographer.valid_password?(params[:photographer][:password])
          render json: { token: encode({ type: 1, user: photographer.id }), photographer_id: photographer.slug }, status: :accepted #note type 1 => photographer
          return
        end
      end
      render json: { errors: ["شماره تماس و یا ایمیل ورودی اشتباه است"] }, status: :unauthorized
    elsif params[:user].present?
      if (user = User.find_by(mobile_number: params[:user][:mobile_number], email: params[:user][:email])).present?
        if user.valid_password?(params[:user][:password])
          render json: { token: encode({ type: 2, user: user.id }) }, status: :accepted #note type 2 => user
        else
          render json: { errors: ["پسورد وارد شده اشتباه است"] }, status: :unauthorized
        end
      else
        render json: { errors: ["شماره تماس و یا ایمیل ورودی اشتباه است"] }, status: :unauthorized
      end
    end
  end
end
