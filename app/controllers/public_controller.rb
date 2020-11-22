class PublicController < ApplicationController
  layout "wordpress"
  respond_to :js

  def contact_us
  end

  def about_us
  end

  def call_request
  end

  def terms
  end

  def privacy
  end

  def faq
  end

  def pricing
  end

  def print_prices
    #// TODO: make routes aacording to SEOed urls
  end

  def join_us
  end

  def enterprises
  end

  def home
  end

  def affiliate
  end

  def backstages
  end

  def news
  end

  def standard_edit
  end

  def retouch_edit
  end

  def create_call_request
    @call_request = CallRequest.new(name: params[:name], phone_number: params[:phone_number], max_budget: params[:max_budget], call_time: params[:call_time], description: params[:description])
    respond_to do |format|
      if @call_request.save
        format.js
      end
    end
  end

  def create_subscribers
    if params[:email].present?
      subscriber = Subscriber.find_by(email: params[:email])
      if !subscriber.present?
        subscriber = Subscriber.new(email: params[:email])
        subscriber.save
      end
    end
  end
end
