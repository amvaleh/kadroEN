include Rails.application.routes.url_helpers
require "#{Rails.root}/app/helpers/application_helper"
include ApplicationHelper
desc "Remind Project to photographer 6 hour before start time"
task ph_project_reminder: :environment do
  @projects = Project.confirmed.today #NOTE we need start_date to filter records here
  @projects.each do |project|
    puts "remembering the project to ph..."
    time = project.start_time
    photographer = project.photographer
    if Time.now + 5.hours <= time && Time.now + 6.hours >= time
      # EmailWorker.perform_async(photographer)
      sms_message = <<-text
      یادآوری پروژه عکاسی #{project.shoot_type.title}، #{project.start_time.strftime("ساعت %H:%M")}
      نام کارفرما:
      #{project.user.display_name}
تا اطلاع بعدی استفاده از ماسک و دستکش حین ورود به پروژه الزامیست و برای سلامت مجموعه بطور جد توسط کادرو پیگیری می شود.
از همراهی شما سپاسگزاریم.
      text
      puts sms_message
      SmsWorker.perform_async(sms_message, photographer.mobile_number)
      project.create_activity :ph_project_reminder, owner: photographer
      SpecialLog.info("ph_project_reminder , start time = #{project.start_time.to_date.to_pdate}- #{project.start_time.strftime("%I:%M%p")} - #{project.start_time.to_date.to_pdate.strftime("%A")} , photographer = #{project.photographer.display_name} , mobile number = #{project.user.mobile_number} , user = #{project.user.display_name}")
    end
  end
end

desc "Remind Project to photographer 1 hour before start time"
task ph_project_reminder_1_hour_before_start_time: :environment do
  @projects = Project.confirmed.today #NOTE we need start_date to filter records here
  @projects.each do |project|
    puts "remembering the project to ph..."
    time = project.start_time
    photographer = project.photographer
    if Time.now <= time && Time.now + 1.hours >= time
      # EmailWorker.perform_async(photographer)
      short_url = Shortener::ShortenedUrl.generate(project_information_project_path(project.slug))
      sms_message = <<-text
یادآوری پروژه عکاسی #{project.shoot_type.title}، #{project.start_time.strftime("ساعت %H:%M")}
اطلاعات پروژه:
http://l.kadro.co/#{short_url.unique_key}
      text
      puts sms_message
      SmsWorker.perform_async(sms_message, photographer.mobile_number)
      project.create_activity :ph_project_reminder, owner: photographer
      SpecialLog.info("ph_project_reminder , start time = #{project.start_time.to_date.to_pdate}- #{project.start_time.strftime("%I:%M%p")} - #{project.start_time.to_date.to_pdate.strftime("%A")} , photographer = #{project.photographer.display_name} , mobile number = #{project.user.mobile_number} , user = #{project.user.display_name}")
    end
  end
end

desc "Remind user to rate project"
task user_reminder_to_rate: :environment do
  @projects = Project.payed.confirmed.joins(:reserve_step).where("reserve_steps.name = ?  or reserve_steps.name = ?  or delivery_at_location = ?", "downloaded", "qualified", true)
  puts "number of projects are #{@projects.size}"
  @projects.each do |project|
    if project.start_time.present?
      unless Time.now - project.start_time > 70.hours and project.rate_reminder_sent.blank?
        next
      end
      if project.photographer.present? and project.user.present?
        short_url = Shortener::ShortenedUrl.generate("/feed_backs/#{project.slug}")

        if project.feed_back.nil? and (project.reserve_step.name == "qualified" or project.reserve_step.name == "downloaded")
          sms_message = <<-text
          #{project.user.display_name} عزیز،
          از اینکه به ما اعتماد کردید، سپاس گزاریم.
          لطفا از طریق لینک زیر نسبت به آزاد سازی مبلغ عکاسی برای پرداخت به عکاس #{project.photographer.display_name} اقدام کنید و نیز نظر خود را درباره عملکرد ایشان ثبت کنید.
          http://l.kadro.co/#{short_url.unique_key}
          با احترام
          text
        elsif project.feed_back.nil?
          sms_message = <<-text
          #{project.user.display_name} عزیز،
          از اینکه به ما اعتماد کردید، سپاس گزاریم.
          لطفا از طریق لینک زیر نظر خود را درباره عملکرد عکاس #{project.photographer.display_name} ثبت کنید.
          http://l.kadro.co/#{short_url.unique_key}
          با احترام
          text
        elsif project.reserve_step.name == "qualified" or project.reserve_step.name == "downloaded"
          if project.delivery_at_location
            short_url = Shortener::ShortenedUrl.generate("/galleries")
          else
            short_url = Shortener::ShortenedUrl.generate("/galleries/#{project.gallery.slug}")
          end
          sms_message = <<-text
          #{project.user.display_name} عزیز،
          از اینکه به ما اعتماد کردید، سپاس گزاریم.
          لطفا از طریق لینک زیر نسبت به آزاد سازی مبلغ عکاسی برای پرداخت به عکاس #{project.photographer.display_name} اقدام کنید.
          http://l.kadro.co/#{short_url.unique_key}
          با احترام
          text
        end

        puts "send sms for project #{project.id}"
        SmsWorker.perform_async(sms_message, project.user.mobile_number)
        if project.delivery_at_location and project.reserve_step != "happy_call" and project.reserve_step != "checkout"
          project.set_reserve_step("downloaded")
        end
        project.create_activity :user_reminder_to_rate
        project.rate_reminder_sent = true

        project.save
      end
    end
  end
end

desc "Check and reject projects whose photographers have not stated their approval yet"
task check_not_approved_projects: :environment do
  Project.payed.joins(:reserve_step).where("reserve_steps.id = ?", 7).each do |project|
    candidates = project.project_candidates
    #waiting photographers
    waiting_photographer = candidates.where(project_candidate_status_id: 2)
    if waiting_photographer.any?
      waiting_candid = waiting_photographer[0]
      if waiting_candid.assigned_at.present?
        spent_time = Time.now - waiting_candid.assigned_at
        remainig_time = 3.hours - spent_time
        hours = (remainig_time / 3600).floor
        start_night = 22
        start_morning = 8
        night_long = 10
        if spent_time >= night_long.hours
          spent_time = spent_time - night_long.hours
        end
        remainig_time = 3.hours - spent_time
        hours = (remainig_time / 3600).floor
        puts hours
        minutes = ((remainig_time - hours * 3600) / 60).round
        puts minutes
        unless is_now_between(start_night, start_morning)
          if spent_time >= 3.hours
            Projects::RejectProject.call(project_id: project.id, project_candidate_id: waiting_candid.id, reason_for_reject_id: 7)
            Projects::SendInformationToPhotographer.call(project_id: project.id, hours: 0, minutes: 0)
            project.create_activity :rake_rejected_project, owner: project.user, recipient: waiting_candid.photographer
          elsif spent_time < 3.hours and spent_time >= 1.hours
            Projects::SendInformationToPhotographer.call(project_id: project.id, hours: hours, minutes: minutes)
          end
        end
      end
    end
  end
end

desc "ask user if you want to extend your project 30 mins before end of time"
task do_you_wanna_extend: :environment do
  puts "asking user for extension the number of projects are:"
  projects = Project.where(:reserve_step_id => ReserveStep.find_by(name: "confirmed").id).shooted.today
  puts projects.count
  projects.each do |p|
    projec_length = convert_package_duration_number(p.package.duration)
    if p.start_time + projec_length.hour - 30.minutes <= Time.now and not p.notify_extend
      # sending sms to user
      puts "sending sms to user for extending photo shoot time"

      short_url = Shortener::ShortenedUrl.generate(extra_hour_project_path(p.slug))

      sms_message = <<-text
#{p.user.display_name} عزیز،
کمتر از ۳۰ دقیقه تا پایان زمان عکاسی شما باقی مانده است.
در صورت تمایل به ادامه دادن عکاسی می توانید از طریق لینک زیر پروژه خود را تمدید کنید:
http://l.kadro.co/#{short_url.unique_key}
با احترام
text
      puts sms_message
      SmsWorker.perform_async(sms_message, p.user.mobile_number)
      ph_message = <<-text
#{p.photographer.display_name} عزیز،
در صورت نیاز کارفرما به تمدید، به ایشان بگویید از لینکی که در پیامک برایشان ارسال شد، در خواست تمدید بیشتر را ثبت و پرداخت کنند تا شما پیامک تاییده تمدید را دریافت کنید.
در صورت عدم تمدید در محل، کادرو مسئولیتی برای پیگیری بعد از پروژه نخواهد داشت.
text
      puts ph_message
      # SmsWorker.perform_async(ph_sms_message, p.photographer.mobile_number)
      Photographers::NotifyForExtend.call(mobile_number: p.photographer.mobile_number, sms_message: ph_message)
      p.notify_extend = true
      p.create_activity :do_you_wanna_extend, owner: p.user
      p.save
    end
  end
end

desc "is_shooted true when Pass start time"
task is_shooted: :environment do
  puts "updateing shoot type task"
  projects = Project.where("projects.reserve_step_id = ? or (projects.reserve_step_id = ? and projects.confirmed = true)", ReserveStep.find_by(name: "confirmed").id, ReserveStep.find_by(name: "change_time").id)
    .where("start_time BETWEEN ? AND ?", Time.now - 1.hour, Time.now)
  projects.each do |project|
    puts project.photographer.display_name
    if project.start_time < Time.now
      project.is_shooted = true
      project.save
      puts "project checked shooted:" + project.id.to_s
    end
  end
end

desc "reminder for 65 hr upload photo period for photographer"
task reminder_for_upload_to_photographer: :environment do
  puts "reminder for upload"
  projects = Project.where(:confirmed => true, :delivery_at_location => false)
    .where("start_time BETWEEN ? AND ?", Time.now - 65.hour, Time.now - 64.hour)
  projects.each do |project|
    if project.is_shooted
      if !project.is_uploaded
        puts project.photographer.display_name
        ReminderForUploadToPhotographerWorker.perform_async(project.id)
        sms_message = <<-text
        کمتر از ۵ ساعت از مهلت شما برای ارسال عکس های پروژه باقی مانده است.
        #{project.user.display_name}، #{project.shoot_type.title}
        تیم کادرو
        text
        SmsWorker.perform_async(sms_message, project.photographer.mobile_number)
        project.create_activity :upload_reminder, owner: project.photographer
      end
    end
  end
end

namespace :general_tasks do
  # update packages photographer commision on the site
  desc "update all packages photographer commision"
  task update_commision_pacakges: :environment do
    Package.all.each do |p|
      puts p.duration.to_s
      case p.duration
      when "هفت ساعت"
        if p.is_full
          p.photographer_commission = 67
          p.price = 630000
        else
          p.photographer_commission = 73
          p.price = 495000
        end
      when "سه ساعت"
        if p.is_full
          p.photographer_commission = 67
          p.price = 380000
        else
          p.photographer_commission = 76
          p.price = 275000
        end
      when "دو ساعت"
        if p.is_full
          p.photographer_commission = 67
          p.price = 280000
        else
          p.photographer_commission = 78
          p.price = 195000
        end
      when "یک ساعت"
        if p.is_full
          p.photographer_commission = 67
          p.price = 165000
        else
          p.photographer_commission = 91
          p.price = 99000
        end
      end
      p.extra_price = 10000
      p.save
    end
  end

  desc "update all orders of packages"
  task update_orders_packages: :environment do
    Package.all.each do |p|
      puts p.rational_distance.to_s
      puts p.duration.to_s
      case p.duration
      when "هفت ساعت"
        p.rational_distance = 4
      when "چهار ساعت"
        p.rational_distance = 4
      when "سه ساعت"
        p.rational_distance = 4
      when "دو ساعت"
        p.rational_distance = 2
      when "یک ساعت"
        p.rational_distance = 2
      end
      p.save
    end
  end

  desc "update average shooted frames of all packages"
  task update_average_shooted_packages: :environment do
    Package.all.each do |p|
      puts p.duration.to_s
      avg = Package.joins(:projects => :gallery).where(:projects => { :confirmed => true }, :packages => { :id => p.id }).average(:total_frames).to_i
      puts "average: #{avg}"
      if avg == 0 or avg < ((p.order * 30) * 0.75)
        avg = (p.order * 30).to_i
      end
      puts "average: #{avg}"
      p.feature_1 = avg.to_s
      p.save
    end
  end

  desc "photo share access (share control) reminder to user"
  task share_control_grant_access_reminder: :environment do
    ShareControl.all.joins(:frame => :gallery).where(:permit => false).group(:gallery_id).count.each do |ss|
      gallery = Gallery.find(ss.first)
      count = ss.second
      short_url = Shortener::ShortenedUrl.generate("/galleries/#{gallery.slug}/permission")
      sms_message = <<-text
      #{gallery.project.user.display_name} عزیز، با سلام، عکاس شما #{gallery.project.photographer.last_name} درخواست اجازه برای استفاده از #{count} عکس به عنوان نمونه کار را برای شما قرارداده است. در صورتیکه مایل هستید به او اجازه دهید از طریق این لینک دسترسی را تعیین کنید:
      http://l.kadro.co/#{short_url.unique_key}
      با احترام
      کادرو
      text
      puts sms_message
      res = SmsWorker.perform_async(sms_message, gallery.project.user.mobile_number)
      puts res
      #return res
    end
  end

  desc "rake for memory plus project amount and reserve step"
  task check_memory_plus_reserve_step: :environment do
    Project.where(delivery_at_location: true, reserve_step_id: [10, 11]).each do |p|
      if (p.start_time + p.package.order.hours) < Time.now
        p.reserve_step_id = 15
        p.qualified_at = Time.now
        p.save
      end
    end
  end

  desc "rake for qualified projects"
  task check_qualified_amount: :environment do
    Project.where("projects.reserve_step_id in (14,15) and projects.is_payed = true and projects.qualified_at is not null").each do |p|
      if ((p.qualified_at) + 7.days) < Time.now
        p.reserve_step_id = 16
        p.save
      end
    end
  end

  desc "set project lead source from user lead source"
  task set_project_lead_source: :environment do
    User.where("users.created_at > '#{(Time.now - 2.month).to_date.strftime("%Y-%m-%d")}'").each do |user|
      if user.lead_source.present?
        user.projects.each do |p|
          unless p.lead_source.present?
            p.lead_source_id = user.lead_source_id
            p.save
          end
        end
      end
    end
  end

  desc "set is_payed_at for old payed projects"
  task set_is_payed_at_with_created_at: :environment do
    Project.payed.each do |p|
      unless p.is_payed_at.present?
        p.is_payed_at = p[:created_at]
        p.save
      end
    end
  end
end
