class ApiController < ApplicationController
  before_action :set_default_format
  before_action :authenticate_token

  private
  def set_default_format
    request.format=:json
  end

  def encode(payload)
    expiration =1.days.from_now.to_i
    JWT.encode payload.merge(exp:expiration),Rails.application.secrets.secret_key_base
  end

  def decode(token)
    JWT.decode(token,Rails.application.secrets.secret_key_base).first
  end

  def authenticate_token
    payload=decode (auth_token)

      if payload.present?
        if payload["type"]==1 #note type 1 => photographer
          @photographer=Photographer.find_by_id(payload["user"])
        elsif payload["type"]==2 #note type 2 => user
          @user=User.find_by_id(payload["user"])
        end
      else
        render json:{errors:["Invalid token"]},status: :unauthorized
      end

     rescue JWT::ExpiredSignature
       render json:{errors:["Token has expired"]},status: :unauthorized
     rescue JWT::DecodeError
       render json:{errors:["Invalid token"]},status: :unauthorized
  end

  def auth_token
    @auth_token ||= request.headers.fetch("Authorization").split(" ").last
  end

  def find_project
    @project = Project.find_by(:slug => params[:project_slug])
  end
end
