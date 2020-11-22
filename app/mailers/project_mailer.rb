class ProjectMailer < ApplicationMailer
  before_action :coupon_create
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.project_mailer.information_to_ph.subject
  #
  def information_to_ph(slug)
    @project = Project.friendly.find(slug)
    @photographer = @project.photographer
    @start_hour = @project.start_hour
    @week_day = @project.week_day
    @address = @project.address
    mail(to: @photographer.email, subject: "پروژه عکاسی جدید #{@project.shoot_type.title}")
    @photographer.create_activity :information_to_ph_email
  end

  def reminder_for_package_step(project_id)
    @project = Project.find(project_id)
    @email = @project.user.email
    res = mail(:to => @email ,:subject => "#{@project.user.display_name} عزیز، سلام، سفارش شما در کادرو " , :content_type => "text/html")
    puts res
  end

  def reminder_for_location_step(project_id)
    @project = Project.find(project_id)
    @email = @project.user.email
    res = mail(:to => @email ,:subject => "#{@project.user.display_name}  عزیز، سلام، سفارش شما در کادرو " , :content_type => "text/html")
    puts res
  end

  def reminder_for_date_step(project_id)
    @project = Project.find(project_id)
    @email = @project.user.email
    res = mail(:to => @email ,:subject => "#{@project.user.display_name} عزیز، سلام، سفارش شما در کادرو " , :content_type => "text/html")
    puts res
  end

  def reminder_for_photographer_step(project_id)
    @project = Project.find(project_id)
    @email = @project.user.email
    res = mail(:to => @email ,:subject => "#{@project.user.display_name}  عزیز، سلام، سفارش شما در کادرو " , :content_type => "text/html")
    puts res
  end

  def reminder_for_canceled_payment_step(project_id)
    @project = Project.find(project_id)
    @email = @project.user.email
    res = mail(:to => @email ,:subject => "#{@project.user.display_name}  عزیز، سلام، سفارش شما در کادرو " , :content_type => "text/html")
    puts res
  end

  def send_gallery_link(project_id)
    @project = Project.find(project_id)
    @email = @project.user.email
    @gallery = @project.gallery
    res = mail(:to => @email ,:subject => "#{@project.user.display_name}  عزیز، عکس های شما حاضر است." , :content_type => "text/html")
    puts res
  end

  def reminder_for_upload_to_photographer(project_id)
    @project = Project.find(project_id)
    @email = @project.photographer.email
    @gallery = @project.gallery
    res = mail(:to => @email ,:subject => "اتمام فرصت آپلود عکسهای پروژه #{@project.shoot_type.title} -  #{@project.user.display_name}" , :content_type => "text/html")
    @project.photographer.create_activity :reminder_for_upload_to_photographer_email
    puts res
  end

  def reminder_for_feed_back_user(project_id)
    @project = Project.find(project_id)
    @email = @project.user.email
    @gallery = @project.gallery
    res = mail(:to => @email ,:subject => "پروژه عکاسی ، #{@project.shoot_type.title} ، #{@project.user.display_name} " , :content_type => "text/html")
    puts res
  end

private

def coupon_create
  value = Setting.find_by_var("reminder_project_coupon").value.to_i
  credit = Setting.find_by_var("reminder_project_coupon_deadline_day").value.to_i
  if value > 0
    if value < 100
      @coupon = Coupon.create(:title => "کد تخفیف برای بازگشت" , :value => value , :is_percent => true , :is_active => true , :valid_from => Time.now , :valid_until => Time.now + credit.day)
    elsif value > 100
      @coupon = Coupon.create(:title => "کد تخفیف برای بازگشت" , :value => value , :is_percent => false , :is_active => true , :valid_from => Time.now , :valid_until => Time.now + credit.day)
    end
  end

end
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.project_mailer.reminder_to_ph.subject
  #
  # def reminder_to_ph(project)
  #   @project = project
  #   @photographer = project.photographer
  #   @start_hour = project.start_hour
  #   @week_day = project.week_day
  #   @address = project.address
  #   mail to: @photographer.email, subject: "یادآوری پروژه امروز"
  # end
end
