module Projects
  class SendDontCheetOverUsPlease
    include Interactor
    include ActionView::Helpers::NumberHelper

    def call
      project = Project.find(context.project_id)
      free_credit = Setting.find_by(var: "free_credit").value
      refer = Refer.find_by(owner_type: "User", owner_id: project.user.id)
      if refer.present?
        code = refer.key
      else
        code = project.user.refer_key
      end
      sms_message = <<-text
#{project.photographer.abbrv_name} را با کد تخفیف #{number_with_delimiter(free_credit.to_i, :delimiter => ",").tr!("0123456789,", "۰۱۲۳۴۵۶۷۸۹،")} به دوستان تان معرفی کنید تا پروژه ثبت کنند و شما هم #{number_with_delimiter(free_credit.to_i, :delimiter => ",").tr!("0123456789,", "۰۱۲۳۴۵۶۷۸۹،")} تومان اعتبار هدیه برای عکاسی بعدی تون بگیرید :
کد:
#{code}
          text
      res = SmsWorker.perform_async(sms_message, project.user.mobile_number)
      context.res = res
    end
  end
end
