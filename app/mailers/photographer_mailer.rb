class PhotographerMailer < ApplicationMailer

  include Rails.application.routes.url_helpers

  def reject_photographer(photographer_id)
    @photographer = Photographer.find(photographer_id)
    @photographer.create_activity :reject_photographer_email
    @email = @photographer.email
    res = mail(:to => @email, :subject => "نتیجه درخواست عضویت در کادرو - #{@photographer.display_name} ", :content_type => "text/html")
    puts res
  end

  def invite_to_interview(photographer_id)
    @photographer = Photographer.find(photographer_id)
    @photographer.create_activity :invite_to_interview_email
    @email = @photographer.email
    res = mail(:to => @email, :subject => "دعوت به مصاحبه - #{@photographer.display_name} ", :content_type => "text/html")
    puts res
  end

  def incomplete_profile(photographer_id)
    @photographer = Photographer.find(photographer_id)
    @photographer.create_activity :incomplete_profile_email
    @email = @photographer.email

    @incomplete_shoot_types = Photographer.joins(expertises: :shoot_type).where(expertises: {approved: false}, id: @photographer.id).select('shoot_types.title').pluck(:title)
    res = mail(:to => @email, :subject => "نتیجه بررسی پروفایل در کادرو - #{@photographer.display_name} ", :content_type => "text/html")
    puts res

  end


  def three_days_past_from_fill_basic_info_reminder(photographer_id)
    @photographer = Photographer.find(photographer_id)
    @email = @photographer.email
    res = mail(:to => @email, :subject => "یادآوری عضویت در کادرو - #{@photographer.display_name} ", :content_type => "text/html")
    puts res
  end

  def seven_days_past_from_fill_basic_info_reminder(photographer_id)
    @photographer = Photographer.find(photographer_id)
    @email = @photographer.email
    res = mail(:to => @email, :subject => "یادآوری عضویت در کادرو - #{@photographer.display_name} ", :content_type => "text/html")
    puts res
  end

  def three_days_past_from_fill_equipment_reminder(photographer_id)
    @photographer = Photographer.find(photographer_id)
    @email = @photographer.email
    res = mail(:to => @email, :subject => "یادآوری عضویت در کادرو - #{@photographer.display_name} ", :content_type => "text/html")
    puts res
  end

  def seven_days_past_from_fill_equipment_reminder(photographer_id)
    @photographer = Photographer.find(photographer_id)
    @email = @photographer.email
    res = mail(:to => @email, :subject => "یادآوری عضویت در کادرو - #{@photographer.display_name} ", :content_type => "text/html")
    puts res
  end

  def reject_and_cancel_membership(photographer_id)
    @photographer = Photographer.find(photographer_id)
    @email = @photographer.email
    res = mail(:to => @email, :subject => "نتیجه بررسی پرفایل - #{@photographer.display_name} ", :content_type => "text/html")
    puts res
  end

  def lack_of_cooperation(photographer_id)
    @photographer = Photographer.find(photographer_id)
    @email = @photographer.email
    res = mail(:to => @email, :subject => "تمایل به عدم همکاری - #{@photographer.display_name} ", :content_type => "text/html")
    puts res
  end
end
