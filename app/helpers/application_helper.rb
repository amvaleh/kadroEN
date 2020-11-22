module ApplicationHelper


  def mobile_device?
    if session[:mobile_param]
      session[:mobile_param] == "1"
    else
      request.user_agent =~ /Mobile|webOS/
    end
  end


  def convert_persian_day(day)
    case day
    when "Saturday"
      "شنبه"
    when "Sunday"
      "یک شنبه"
    when "Monday"
      "دو شنبه"
    when "Tuesday"
      "سه شنبه"
    when "Wednesday"
      "چهار شنبه"
    when "Thursday"
      "پنج شنبه"
    when "Friday"
      "جمعه"
    end
  end

  def convert_persian_number_day(day,is_input_number=false)
    if is_input_number==false
      case day
      when "شنبه"
        return 1
      when "یک‌شنبه"
        return 2
      when "دوشنبه"
        return 3
      when "سه‌شنبه"
        return 4
      when "چهارشنبه"
        return 5
      when "پنج‌شنبه"
        return 6
      when "جمعه"
        return 7
      end
    else
      case day
      when 1
        return "شنبه"
      when 2
        return "یک شنبه"
      when 3
        return "دو شنبه"
      when 4
        return "سه شنبه"
      when 5
        return "چهار شنبه"
      when 6
        return "پنج شنبه"
      when 7
        return "جمعه"
      end
    end

  end

  def number (to_convert, locale, text = nil)
    to_convert = to_convert.to_i.to_s
    case locale
    when 'fa'
      to_convert = to_convert.unpack('U*').map{ |e| e + 1728 }.pack('U*')
      text ? to_convert + ' ' + text : to_convert
    else
      text ? to_convert + ' ' + text : to_convert
    end
  end

  def convert_package_duration_number(duration)
    case duration
    when "۳۰ دقیقه"
      return 0.5
    when "یک ساعت"
      return 1
    when "دو ساعت"
      return 2
    when "سه ساعت"
      return 3
    when "چهار ساعت"
      return 4
    when "هفت ساعت"
      return 7
    end
  end

  def environment_url
    if Rails.env.production?
      return "kadro.co"
    else
      return "localhost:3000"
    end
  end

  def like_url
    if Rails.env.production?
      return "https://app.kadro.co/selectable_images/like"
    elsif Rails.env.development?
      return "http://app.localhost:3000/selectable_images/like"
    elsif Rails.env.staging?
      return "http://185.53.143.141:3005/selectable_images/like"
    end
  end

  def second_environment_url
    if Rails.env.production?
      return "app.kadro.co"
    elsif Rails.env.development?
      return "app.localhost:3000"
    elsif Rails.env.staging?
      return "http://185.53.143.141:3005"
    end
  end

  def track(id,name, email, absent_day , type)
    case(type)
    when('photographer')
      record = SentPhotographerEmail.create!(:photographer_id => id ,:name => name, :email => email, :sent => DateTime.now , :absent_day => absent_day)
      url = "https://#{second_environment_url}/email/track/#{Base64.strict_encode64("type=#{type}&name=#{name}&email=#{email}&id=#{record.id}")}.png"
      raw("<img src=\"#{url}\" alt="" width=\"1\" height=\"1\">")
    when('user')
      record = SentUserEmail.create!(:user_id => id ,:name => name, :email => email, :sent => DateTime.now , :absent_day => absent_day)
      url = "https://#{second_environment_url}/email/track/#{Base64.strict_encode64("type=#{type}&name=#{name}&email=#{email}&id=#{record.id}")}.png"
      raw("<img src=\"#{url}\" alt="" width=\"1\" height=\"1\">")
    when('project')
      record = SentProjectEmail.create!(:project_id => id ,:name => name, :email => email, :sent => DateTime.now , :absent_day => absent_day)
      url = "https://#{second_environment_url}/email/track/#{Base64.strict_encode64("type=#{type}&name=#{name}&email=#{email}&id=#{record.id}")}.png"
      raw("<img src=\"#{url}\" alt="" width=\"1\" height=\"1\">")
    end
  end

  def bootstrap_class_for flash_type
    case flash_type.to_s
    when 'notice'
      'alert-info'
    when 'alert'
      'alert-warning'
    when 'success'
      'alert-success'
    when 'error'
      'alert-danger'
    when 'alert'
      'alert-warning'
    end
  end

  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      return if (message.blank?) or (msg_type == 'timedout')
      concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)} fade in") do
        concat content_tag(:i, '', class: 'fa fa-times close', data: { dismiss: 'alert' })
        concat message
      end)
    end
    nil
  end

  def order_to_duration(order_recieved)
    case order_recieved
    when 1
        1.hour
      when 2
        2.hours
      when 3
        3.hours
      when 4
        4.hours
      when 5
        5.hours
      when 6
        6.hours
      when 7
        7.hours
      else
        1.hour
    end
  end

  def is_now_between(first_hour, second_hour)
    now = Time.now
    if (0..8).cover? now.hour
      a = now - 1.day
    else
      a = now
    end
    start = Time.new a.year, a.month, a.day, first_hour, 0, 0
    b = a + 1.day
    stop = Time.new b.year, b.month, b.day, second_hour, 0, 0
    (start..stop).cover? now
  end

end
