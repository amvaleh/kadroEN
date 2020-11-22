class MailviewController < ApplicationController

  layout "test"

  def order_recieved
    @text = "سفارش شما دریافت شد."
    @project = Project.payed.last
  end
end
