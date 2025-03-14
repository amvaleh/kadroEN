Lookup.find_or_create_by(category: 'payment_status', code: 1, title: 'ثبت شده')
Lookup.find_or_create_by(category: 'payment_status', code: 2, title: 'آماده برای پرداخت')
Lookup.find_or_create_by(category: 'payment_status', code: 3, title: 'پرداخت شده')
Lookup.find_or_create_by(category: 'payment_status', code: 4, title: 'ابطال شده')
Lookup.find_or_create_by(category: 'payment_status', code: 5, title: 'در انتظار پرداخت')
Lookup.find_or_create_by(category: 'payment_status', code: 6, title: 'دارای خطا')

Lookup.find_or_create_by(category: 'payment_type', code: 1, title: 'پروژه عکاسی')
Lookup.find_or_create_by(category: 'payment_type', code: 2, title: 'تمدید ساعت بیشتر')
Lookup.find_or_create_by(category: 'payment_type', code: 3, title: 'خرید از فروشگاه')
Lookup.find_or_create_by(category: 'payment_type', code: 4, title: 'رفت و آمد')


Lookup.find_or_create_by(category: 'user.sign_in', title: 'ورود')
Lookup.find_or_create_by(category: 'user.sign_out', title: 'خروج')
Lookup.find_or_create_by(category: 'user.started_a_project', title: 'شروع پروژه')
Lookup.find_or_create_by(category: 'user.submitted_delivery_false', title: 'انتخاب سرویس گالری آنلاین')
Lookup.find_or_create_by(category: 'user.submitted_delivery_true', title: 'انتخاب سرویس مموری پلاس')
Lookup.find_or_create_by(category: 'user.submitted_package', title: 'مرحله انتخاب پکیج')
Lookup.find_or_create_by(category: 'user.submitted_address', title: 'مرحله انتخاب آدرس')
Lookup.find_or_create_by(category: 'user.submitted_shoot_type', title: 'مرحله انتخاب رشته عکاسی')
Lookup.find_or_create_by(category: 'user.registered_and_started_a_project', title: 'مرحله شروع رزرو عکاس')
Lookup.find_or_create_by(category: 'user.submitted_photographer', title: 'مرحله انتخاب عکاس')
Lookup.find_or_create_by(category: 'user.submitted_detail', title: 'مرحله انتخاب جزییات پروژه')
Lookup.find_or_create_by(category: 'user.bank_gateway', title: 'ورود کاربر به درگاه بانکی')
Lookup.find_or_create_by(category: 'user.not_succeed_in_payment', title: 'پرداخت ناموفق پروژه')
Lookup.find_or_create_by(category: 'user.succeed_in_payment', title: 'پرداخت موفق پروژه')
Lookup.find_or_create_by(category: 'user.see_his_gallery', title: 'مشاهده گالری')
Lookup.find_or_create_by(category: 'user.downloaded_all', title: 'دانلود همه عکس ها')
Lookup.find_or_create_by(category: 'user.downloaded_original', title: 'دانلود یک فریم')
Lookup.find_or_create_by(category: 'user.couldnt_download', title: 'دانلود ناموفق یک فریم')
Lookup.find_or_create_by(category: 'user.created_invoice', title: 'خرید از فروشگاه')
Lookup.find_or_create_by(category: 'user.succeed_in_extra_payment', title: 'پرداخت موفق تمدید')
Lookup.find_or_create_by(category: 'user.not_succeed_in_extra_payment', title: 'پرداخت ناموفق تمدید')
Lookup.find_or_create_by(category: 'user.not_success_invoice_pay', title: 'پرداخت ناموفق خرید از فروشگاه')
Lookup.find_or_create_by(category: 'user.payed_invoice', title: 'پرداخت موفق خرید از فروشگاه')
Lookup.find_or_create_by(category: 'user.submitted_extra_hour', title: 'تمدید')
Lookup.find_or_create_by(category: 'user.submitted_coupon', title: 'اسفاده از کد تخفیف')
Lookup.find_or_create_by(category: 'user.set_date_time', title: 'انتخاب زمان پروژه')
Lookup.find_or_create_by(category: 'user.entered_his_email', title: 'وارد کردن ایمیل')
Lookup.find_or_create_by(category: 'user.set_password_for_gallery', title: 'تنظیم پسورد گالری')
Lookup.find_or_create_by(category: 'user.cleared_password_of_gallery', title: 'حذف پسورد گالری')
Lookup.find_or_create_by(category: 'user.downloaded_receipt', title: 'دانلود فاکتور فروشگاه')
Lookup.find_or_create_by(category: 'user.use_invoice_coupon', title: 'استفاده از کوپن فروشگاه')
Lookup.find_or_create_by(category: 'user.remove_invoice_coupon', title: 'حذف کوپن فروشگاه')



Lookup.find_or_create_by(category: 'photographer.ph_update_scanned_profile', title: 'آپدیت مدارک')
Lookup.find_or_create_by(category: 'photographer.ph_upload_frame', title: 'آپلود عکس')
Lookup.find_or_create_by(category: 'photographer.ph_update_info', title: 'آپدیت اطلاعات اولیه')
Lookup.find_or_create_by(category: 'photographer.ph_update_bank_account', title: 'آپدیت اطلاعات بانکی')
Lookup.find_or_create_by(category: 'photographer.ph_edit_equipments', title: 'آپدیت تجهیزات')
Lookup.find_or_create_by(category: 'photographer.ph_edit_experience', title: 'آپدیت تجربه کاری')
Lookup.find_or_create_by(category: 'photographer.ph_edit_portfolio', title: 'آپدیت نمونه کار')
Lookup.find_or_create_by(category: 'photographer.ph_see_project_info', title: 'مشاهده اطلاعات پروژه')
Lookup.find_or_create_by(category: 'photographer.ph_approve_project', title: 'قبول پروژه')
Lookup.find_or_create_by(category: 'photographer.ph_change_time_project', title: 'تغییر تاریخ پروژه')
Lookup.find_or_create_by(category: 'photographer.ph_reject_project', title: 'رد پروژه')
Lookup.find_or_create_by(category: 'photographer.ph_feedback_project', title: 'امتیاز دهی به پروژه')
Lookup.find_or_create_by(category: 'photographer.ph_join_location_info', title: 'ثبت اطلاعات مکانی')
Lookup.find_or_create_by(category: 'photographer.ph_join_experience', title: 'ثبت تجربه کاری')
Lookup.find_or_create_by(category: 'photographer.ph_sign_in', title: 'ورود')
Lookup.find_or_create_by(category: 'photographer.ph_sign_out', title: 'خروج')
Lookup.find_or_create_by(category: 'photographer.ph_delete_a_photo', title: 'حذف یک عکس')
Lookup.find_or_create_by(category: 'photographer.ph_add_expertise', title: 'افزودن تخصص')
Lookup.find_or_create_by(category: 'photographer.ph_add_photo', title: 'آپلود عکس در نمونه کار')
Lookup.find_or_create_by(category: 'photographer.ph_join_equipments', title: 'ثبت تجهیزات')
Lookup.find_or_create_by(category: 'photographer.ph_delete_expertise', title: 'حذف تخصص')
Lookup.find_or_create_by(category: 'photographer.ph_join_expertises', title: 'ثبت نمونه کار')
Lookup.find_or_create_by(category: 'photographer.ph_join_prime_info', title: 'ثبت نام و اطلاعات اولیه')
Lookup.find_or_create_by(category: 'photographer.ph_upload_profile_photo', title: 'آپلود عکس پروفایل')
Lookup.find_or_create_by(category: 'photographer.reject_photographer_email', title: 'ایمیل ریجکت')
Lookup.find_or_create_by(category: 'photographer.invite_to_interview_email', title: 'ایمیل دعوت به مصاحبه')
Lookup.find_or_create_by(category: 'photographer.incomplete_profile_email', title: 'ایمیل پروفایل ناقص')
Lookup.find_or_create_by(category: 'photographer.information_to_ph_email', title: 'ایمیل پروژه جدید')
Lookup.find_or_create_by(category: 'photographer.reminder_for_upload_to_photographer_email', title: 'ایمیل یادآوری آپلود عکس')
Lookup.find_or_create_by(category: 'photographer.ph_settled_successfully', title: 'تسویه توسط عکاس')


Lookup.find_or_create_by(category: 'project.submitted_photographer', title: 'مرحله انتخاب عکاس')
Lookup.find_or_create_by(category: 'project.submitted_package', title: 'مرحله انتخاب پکیج')
Lookup.find_or_create_by(category: 'project.submitted_coupon', title: 'اسفاده از کد تخفیف')
Lookup.find_or_create_by(category: 'project.submitted_shoot_type', title: 'مرحله انتخاب رشته عکاسی')
Lookup.find_or_create_by(category: 'project.submitted_address', title: 'مرحله انتخاب آدرس')
Lookup.find_or_create_by(category: 'project.set_new_photographer', title: 'انتخاب عکاس جایگزین')
Lookup.find_or_create_by(category: 'project.bank_gateway_to_pay_negative_credit', title: 'پرداخت کردیت منفی')
Lookup.find_or_create_by(category: 'project.upload_done', title: 'اتمام آپلود')
Lookup.find_or_create_by(category: 'project.user_reminder_to_rate', title: 'یادآوری نمره دهی به عکاس')
Lookup.find_or_create_by(category: 'project.ph_project_reminder', title: 'یادآوری پروژه به عکاس')
Lookup.find_or_create_by(category: 'project.do_you_wanna_extend', title: 'پیامک تمدید')
Lookup.find_or_create_by(category: 'project.upload_reminder', title: 'یادآوری مهلت آپلود عکس')
Lookup.find_or_create_by(category: 'project.start_project_sms', title: 'پیامک شروع عکاسی')
Lookup.find_or_create_by(category: 'project.remind_user_see_gallery', title: 'پیامک گالریتو ببین')
Lookup.find_or_create_by(category: 'project.rake_rejected_project', title: 'ریجکت پروژه توسط کادرو')



Lookup.find_or_create_by(category: 'admin_user.create', title: 'ساخت')
Lookup.find_or_create_by(category: 'admin_user.update', title: 'ویرایش')
Lookup.find_or_create_by(category: 'admin_user.destroy', title: 'حذف')
Lookup.find_or_create_by(category: 'admin_update', title: 'ویرایش')

Lookup.find_or_create_by(category: 'shop_status', code: 0, title: 'ثبت شده')
Lookup.find_or_create_by(category: 'shop_status', code: 1, title: 'پرداخت شده')

Lookup.find_or_create_by(category: 'relation_type', code: 1, title: 'مستقل')
Lookup.find_or_create_by(category: 'relation_type', code: 2, title: 'مرتبط با کالا و خدمات')
Lookup.find_or_create_by(category: 'relation_type', code: 3, title: 'مرتبط با مشتری')
Lookup.find_or_create_by(category: 'relation_type', code: 4, title: 'مرتبط با کالا و مشتری')
Lookup.find_or_create_by(category: 'factor_type', code: 1, title: 'افزاینده')
Lookup.find_or_create_by(category: 'factor_type', code: 2, title: 'کاهنده')
Lookup.find_or_create_by(category: 'value_type', code: 1, title: 'مبلغی')
Lookup.find_or_create_by(category: 'value_type', code: 2, title: 'درصدی')
