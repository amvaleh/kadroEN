Setting.find_or_create_by(:var=>"distance",:value=>"40", :description=>"شعاع پیدا کردن عکاس برای درخواست پروژه")
Setting.find_or_create_by(:var=>"reminder_project_coupon",:value=>"0", :description=>"مقدار تخفیف برای کپن های یادآوری کننده کاربر")
Setting.find_or_create_by(:var=>"reminder_project_coupon_deadline_day",:value=>"0", :description=>"مدت زمان استفاده کردن از کپن یادآوری کننده کاربر بر اساس روز")
Setting.find_or_create_by(:var=>"reminder_project_period_hour",:value=>"3", :description=>"مدت زمان گذشتن از درخواست جدید برای یادآوری بر اساس ساعت")
Setting.find_or_create_by(:var=>"reminder_completing_sms_period_hour",:value=>"3", :description=>"مدت زمان گذشتن از ساخت کاربر جدید برای ارسال اس ام اس به او")
Setting.find_or_create_by(:var=>"reminder_completing_sms_url",:value=>"https://www.kadro.co/", :description=>"صفحه فرود برای یادآوری کننده های اس ام اس")
Setting.find_or_create_by(:var=>"photographer_extra_hour_commission",:value=>"70", :description=>"مقدار سهم عکاس در هر نیم ساعت یا یک ساعت تمدید (درصد)")
Setting.find_or_create_by(:var=>"half_hour_extend_cost",:value=>"70000", :description=>"هزینه تمدید نیم ساعت بیشتر برای مشتری به تومان ")
Setting.find_or_create_by(:var=>"one_hour_extend_cost",:value=>"120000", :description=>"هزینه تمدید یک ساعت بیشتر برای مشتری به تومان")
Setting.find_or_create_by(:var=>"photographer_extra_hour_commission",:value=>"70", :description=>"مقدار سهم عکاس در هر نیم ساعت یا یک ساعت تمدید (درصد)")
Setting.find_or_create_by(:var=>"half_hour_extend_cost",:value=>"70000", :description=>"هزینه تمدید نیم ساعت بیشتر برای مشتری به تومان ")
Setting.find_or_create_by(:var=>"one_hour_extend_cost",:value=>"120000", :description=>"هزینه تمدید یک ساعت بیشتر برای مشتری به تومان")
Setting.find_or_create_by(:var=>"reminder_completing_feedback_period_day",:value=>"2", :description=>"مدت زمان گذشته شده از نظر ندادن مشتری به گالری (روز)")
Setting.find_or_create_by(var: 'photographer_shopping_commission',
  value: 5,
  description: 'سهم عکاس از چاپ')
Setting.find_or_create_by(var: 'photographer_exrta_download_commission',
    value: 50,
    description: 'سهم عکاس از خرید فایل بیشتر')

Setting.find_or_create_by(var: 'service_commission',value: 10, description: 'سهم عکاس از سرویس')
Setting.find_or_create_by(var: 'payment_gateway',value: 'zarinpal', description: 'درگاه بانک')
Setting.find_or_create_by(var: 'extra_transportation',value: '2500', description: "هزینه اضافه رفت ، آمد عکاس خارج از محدوده بر واحد کیلومتر به تومان")


Setting.find_or_create_by(var: 'book_link',value: 'https://app.kadro.co/book', description: "لینک دعوت به تکمیل سفارش که در پیامک زمانیکه مشتری تلفن را پاسخ نداده و سفارش را ناقص رها کرده است ارسال می شود.")

Setting.find_or_create_by(var: 'free_credit', value: 40000)