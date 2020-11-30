namespace :user_tasks do
  desc "TODO"
  task remove_duplicates: :environment do
    visions = []
    puts "start"
    User.all.each do |user|
      counter = 0
      conditional = false
      if visions.any?
        visions.each do |vision|
          if user.id == vision
            conditional = true
          end
        end
      end
      if conditional
        next
      end
      User.all.each do |user2|
        if user.id == user2.id
          next
        end
        if user.mobile_number == user2.mobile_number
          puts "repeat #{user.id}"
          # projects = Project.all.joins(:users).where(:users => {:mobile_number => user.mobile_number})
          projects = Project.all.where(:user_id => user2.id)
          if projects.any?
            projects.each do |project|
              project.user = user
              project.save
            end
          end
          not_present = true
          if visions.any?
            visions.each do |vision|
              if user2.id == vision
                not_present = false
              end
            end
          end
          if not_present
            visions << user2.id
            counter = counter + 1
          end
        end
      end
      if counter == 0
      else
        increas = user.repeated_times
        user.repeated_times = counter + increas
        user.save
      end
    end
    if visions.any?
      visions.each do |vision|
        # puts("cleaned...")
        User.find_by_id(vision).destroy
      end
    end
  end

  desc "start_project_sms"
  task project_started_sms: :environment do
    projects = Project.confirmed.today
    projects.each do |project|
      start_time = project.start_time
      if Time.now > start_time && Time.now < start_time + 30.minutes
        short_url = Shortener::ShortenedUrl.generate(extra_hour_project_path(project.slug))

        sms_message = <<-text
#{project.user.display_name} عزیز،
زمان عکاسی شما از ساعت #{project.start_time.strftime("%H:%M")} شروع شده است و به مدت #{project.package.duration} ادامه خواهد داشت.
در صورت تمایل به تمدید از طریق لینک زیر اقدام فرمایید.
http://l.kadro.me/#{short_url.unique_key}
با احترام
کادرو
        text
        SmsWorker.perform_async(sms_message, project.user.mobile_number)

        project.create_activity :start_project_sms, owner: project.user
      end
    end
  end

  desc "Remind user to see his gallery"
  task user_reminder_to_see_gallery: :environment do
    @projects = Project.joins(:reserve_step).where("reserve_steps.name = ?", "qualified")
    puts "number of projects are #{@projects.size}"
    @projects.each do |project|
      if project.send_customer_at.present?
        if Time.now - project.send_customer_at >= 70.hours and Time.now - project.send_customer_at <= 94.hours
          short_url = Shortener::ShortenedUrl.generate("/galleries/#{project.gallery.slug}")

          sms_message = <<-text
سلام #{project.user.display_name} عزیز،
عکس های شما در گالری خصوصی تان قرار گرفته است، از طریق لینک زیر می توانید نسبت به دانلود، اشتراک گذاری و سفارش چاپ عکس اقدام فرمایید.
http://l.kadro.me/#{short_url.unique_key}
با احترام
          text
          puts "send sms for project #{project.id}"
          SmsWorker.perform_async(sms_message, project.user.mobile_number)

          project.create_activity :remind_user_see_gallery, owner: project.user
        end
      end
    end
  end

  task generate_slug: :environment do
    users = User.where("coalesce(slug, '') = ''").load
    users.each do |user|
      slug = Kadro::GenerateSlug.call(model: User).random_token
      User.where(id: user.id).update_all(slug: slug)
    end
  end

  task check_birthday: :environment do
    users = User.where("birthday_date IS NOT NULL")
    users.each do |user|
      birthday = user.birthday_date
      date = Date.new(Date.today.year, birthday.month, birthday.day)
      date = date - 10.days
      if date == Time.now.to_date
        value_coupon = Setting.find_by_var("percent_for_birthday_coupons").value.to_i
        raw_string = SecureRandom.random_number(2 ** 80).to_s
        long_code = raw_string.tr("0123456789", "234679")
        code = user.mobile_number[4..8] + long_code[4..5]
        coupon = Coupon.create(title: "کد تخفیف تولد " + user.display_name, value: value_coupon, is_percent: true, applied_times: 0, valid_from: Time.now, valid_until: (Time.now + 11.days), is_active: true, user_id: user.id)
        coupon.code = code
        coupon.save
        short_url = Shortener::ShortenedUrl.generate("/book?utm_source=10percent_coupon&utm_medium=sms&utm_campaign=users_birth_gift")
        message = <<-SMS
۲۴۰ ساعت دیگه تولد داریم
تولدت پیشاپیش مبارک #{user.display_name_for_message} عزیز
هدیه کادرو به شما کد تخفیف #{value_coupon} درصدی می باشد.
کد تخفیف : #{code}
برای رزرو عکاس بزن رو لینک پایین:
http://l.kadro.me/#{short_url.unique_key}
مهلت استفاده #{user.birthday_date.to_pdate.strftime("%e")} #{user.birthday_date.to_pdate.strftime("%b")} ماه
کادرو
        SMS
        SmsWorker.perform_async(message, user.mobile_number)
        if user.email.present?
          SendCouponForBirthdayEmailWorker.perform_async(coupon.id)
          puts user.email
        end
      end
    end
  end
  task change_project_user: :environment do
    old_user = User.find_by(mobile_number: "09126902924")
    new_user = User.find_by(mobile_number: "09127043518")
    projects = Project.where(user_id: old_user.id).payed
    projects.each do |p|
      p.user = new_user
      p.save    
      puts "changed"  
    end
  end
end
