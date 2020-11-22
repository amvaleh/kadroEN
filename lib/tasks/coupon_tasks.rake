namespace :coupon_tasks do
  desc "TODO"
  task check_in_range_is_active: :environment do
    Coupon.is_active.each do |coupon|
      if coupon.valid_from.present? && coupon.valid_until.present?
        if !Time.now.between?(coupon.valid_from, coupon.valid_until)
          coupon.is_active = false
          coupon.save
        end
      end
    end
  end

  task generate_coupon: :environment do
    # i = 0
    coupons = []
    p "Start Time: #{Time.now}"
    100000.times do
      random_number = 0
      loop do
        random_number = SecureRandom.random_number(10000000..99999999)
        break random_number unless Coupon.exists?(code: random_number)
      end
      coupons << { title: "کمپین نوروز ۹۸ ایرانسل",
                   value: 20,
                   is_percent: true,
                   code: random_number,
                   is_active: true,
                   used_times: 0,
                   valid_from: "2019-03-06",
                   valid_until: "2019-04-19",
                   redemption_limit: 2,
                   number_of_repetitions: 1,
                   auto_generate: true }
    end
    p "Codes Generated."
    Coupon.create(coupons)
    p "Finish Time: #{Time.now}"
  end

  task generate_coupon_2: :environment do
    # i = 0
    coupons = []
    p "Start Time: #{Time.now}"
    random_number = 100000
    350000.times do
      CouponCode.create(code: "22#{random_number}")
      random_number += 1
    end
    p "Finish Time: #{Time.now}"
  end

  task generate_coupon_for_shop: :environment do
    coupons = []
    title = "کد تخفیف ۸۰ درصد برای چاپ و شاسی و روتوش، هدیه دیجیکالا"
    value = 80
    type = "Percent"
    redemption_limit = 1
    number_of_repetitions = 1
    is_active = true
    used_times = 0
    is_first_order = false
    # factor details
    relation_type = 1
    factor_type = 2
    p "Start Time: #{Time.now}"
    random_number = 100000
    1000.times do
      if type == "Percent"
        coupon = Coupon.create(title: title, is_percent: true, is_active: is_active, redemption_limit: redemption_limit, used_times: used_times, is_first_order: is_first_order, number_of_repetitions: number_of_repetitions, value: 0)
        factor = Factor.create(title: title, coupon_id: coupon.id, value: value, factor_type: factor_type, relation_type: relation_type, value_type: 2)
      elsif type == "Fix"
        coupon = Coupon.create(title: title, is_percent: false, is_active: is_active, redemption_limit: redemption_limit, used_times: used_times, is_first_order: is_first_order, number_of_repetitions: number_of_repetitions, value: 0)
        factor = Factor.create(title: title, coupon_id: coupon.id, value: value, factor_type: factor_type, relation_type: relation_type, value_type: 1)
      end
    end
    p "Finish Time: #{Time.now}"
  end
end
