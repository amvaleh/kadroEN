require 'json'
require "net/http"
require "uri"
namespace :photographer_tasks do
  desc "automated rate calculator"
  task calculate_rate: :environment do
    Photographer.all.each do |photographer|
      projects = photographer.projects
      qrates = []
      arates = []
      projects.each do |project|
        if project.feed_back.present?
          qrates << project.feed_back.qrate
          arates << project.feed_back.arate
        end
      end
      if qrates.count == 0 && arates.count == 0
        photographer.qrate = 10
        photographer.arate = 10
      elsif qrates.count == 0
        photographer.qrate = 10
        arate_sum = 0
        arates.each do |a|
          arate_sum = arate_sum + a
        end
        photographer.arate = arate_sum.to_f / arates.count
      elsif arates.count == 0
        photographer.arate = 10
        qrate_sum = 0
        qrates.each do |q|
          qrate_sum = qrate_sum + q
        end
        photographer.qrate = qrate_sum.to_f / qrates.count
      else
        qrate_sum = 0
        arate_sum = 0
        qrates.each do |q|
          qrate_sum = qrate_sum + q
        end
        arates.each do |a|
          arate_sum = arate_sum + a
        end
        photographer.qrate = qrate_sum.to_f / qrates.count
        photographer.arate = arate_sum.to_f / arates.count
      end
      photographer.save
    end
  end
  desc 'Remind Backstage to photographer'
  task ph_backstage_reminder: :environment do
    @projects = Project.confirmed.today #NOTE we need start_date to filter records here
    @projects.each do |project|
      puts "remembering the Backstage to ph..."
      time = project.start_time
      photographer = project.photographer
      if Time.now <= time && Time.now + 1.hours >= time
        sms_message = <<-text
  #{photographer.first_name} عزیز.
  کمتر از یک ساعت تا پروژه #{project.user.full_name} زمان مانده است، برای تولید محتوای تبلیغی جذاب یک ویدئو کوتاه مانند لینک زیر تهیه کنید و در واتس اپ برای ما بفرستید.
  https://kadro.co/ts
        text
        puts sms_message
        SmsWorker.perform_async(sms_message, photographer.mobile_number)
        project.create_activity :ph_backstage_reminder, owner: photographer
      end
    end
  end

end

desc "update area name of photographer's location with neshan map"
task sync_fa_area_name: :environment do
  Photographer.all.approved.each do |ph|
    puts " -- :" + ph.display_name + ": -- "
    if ph.location.present?
      lat = ph.location.working_lat
      long = ph.location.working_long
      url = URI.parse("https://api.neshan.org/v2/reverse?lat=#{lat}&lng=#{long}")
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      req = Net::HTTP::Get.new(url.request_uri)
      req["Api-Key"] = "service.zxfXcIUQnzlR97KubhRmAZXvwvOKdqBNXRKazF0X"
      response = http.request(req)
      res = JSON.parse(response.body)
      puts "res:" + response.body
      puts " "
      puts "prev:" + ph.location.area_name.to_s
      city = res["city"].present? ? res["city"] : res["state"]
      ph.location.area_name = city.to_s+"-"+res["neighbourhood"].to_s
      ph.location.working_input = ph.location.area_name
      if res["addresses"].present?
        ph.location.working_input = ph.location.working_input + "-"+ res["addresses"].first["formatted"].to_s
      end
      # ph.location.save
      puts "new area: " + ph.location.area_name
      puts "new: adrs" + ph.location.working_input
      if res["neighbourhood"] == ""
        puts "isnil"
      end
    else
      puts "No Location Record"
    end
    puts " "
    puts " "
  end

end

desc "update approved at of old photographers"
task update_approved_at: :environment do
  Photographer.all.approved.each do |ph|
    if ph.approved_at.nil?
      ph.approved_at = ph.updated_at
      puts ph.display_name
      ph.save
    end
  end
end


desc "remember photographer about updating calendar"
task update_your_calendar_reminder: :environment do
  Photographer.all.approved.each do |ph|
    available_hours = FreeTimes::CalculateAvailableWeekHours.call(photographer_id:ph.id).available_hours
    short_url = Shortener::ShortenedUrl.generate(times_photographer_path(ph.slug))
    count = 0
    ph.free_times.each do |ft|
      if ft.day != 8
        count = count +1
      end
    end
    if count <0 or available_hours < 10
      sms_message = <<-text
#{ph.display_name} عزیز.
تقویم شما زمان کافی برای رزرو ندارد، جهت ثبت زمانهای بیشتر:
http://l.kadro.co/#{short_url.unique_key}
دوستدار شما، کادرو
      text
    else
      sms_message = <<-text
#{ph.display_name} عزیز.
تقویم جاری شما #{available_hours} ساعت زمان خالی در #{count} روز هفته دارد.
جهت به روز ماندن تقویم خود:
http://l.kadro.co/#{short_url.unique_key}
دوستدار شما، کادرو
      text
    end
    puts sms_message
    puts " "
    SmsWorker.perform_async(sms_message, ph.mobile_number)
  end
end
