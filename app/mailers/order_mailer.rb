class OrderMailer < ApplicationMailer
  include Rails.application.routes.url_helpers
  def order_recieved(project)
    @project = Project.find_by(slug: project)
    @email = @project.user.email
    res = mail(:to => @email ,:subject => "#{@project.user.display_name}  عزیز، سلام، سفارش شما تایید شد." , :content_type => "text/html")
    puts res
  end

  def reject_photographer(photographer)
    @photographer = photographer
    @email = @photographer.email
    res = mail(:to => @email ,:subject => "#{@photographer.display_name} عزیز، سلام، درخواست شما بررسی شد." , :content_type => "text/html")
    puts res
  end
end
