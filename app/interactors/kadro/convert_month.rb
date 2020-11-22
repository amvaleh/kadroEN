module Kadro
  class ConvertMonth
    include Interactor
    def call
      case context.month
      when "01"
        context.result = "فروردین"
      when "02"
        context.result = "اردیبهشت"
      when "03"
        context.result = "خرداد"
      when "04"
        context.result = "تیر"
      when "05"
        context.result = "مرداد"
      when "06"
        context.result = "شهریور"
      when "07"
        context.result = "مهر"
      when "08"
        context.result = "آبان"
      when "09"
        context.result = "آذر"
      when "10"
        context.result = "دی"
      when "11"
        context.result = "بهمن"
      when "12"
        context.result = "اسفند"
      else
        context.fail!
      end
    end
  end
end
