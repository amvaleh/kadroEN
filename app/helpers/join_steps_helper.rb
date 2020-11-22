module JoinStepsHelper

  def photographer_next_join_step(photographer)
    case photographer.join_step.name
    when "اطلاعات اولیه"
      equipments_photographer_path(photographer)
    when "تجهیزات عکاسی"
      portfolio_photographer_path(photographer)
    when "نمونه کارها"
      experience_photographer_path(photographer)
    when "تجربه کاری"
      done_photographer_path(photographer)
    when "تاییدیه"
      studio_photographer_path(photographer)
    end
  end
end
