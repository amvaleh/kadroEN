module Photographers
  class PortfolioCreate
    include Interactor

    def call
      photographer = Photographer.find(context.data[:id])
      photographer.uid = context.data[:uid]
      photographer.online_portfolio = context.data[:online_portfolio]
      photographer.instagram = context.data[:instagram]
      photographer.linkedin = context.data[:linkedin]
      photographer.twitter = context.data[:twitter]
      photographer.avatar = context.data[:avatar] if context.data[:avatar]
      unless photographer.join_step.name == "تاییدیه" || context.data[:change_step].to_i == 0
        if photographer.join_step.code <= JoinStep.find_by_name("تجهیزات عکاسی").code
          photographer.join_step_id = JoinStep.find_by_name("نمونه کارها").id # to skip update if ph is confirmed
          photographer.create_activity :ph_join_expertises, owner: photographer
        else
          photographer.create_activity :ph_edit_portfolio, owner: photographer
        end
      else
        photographer.create_activity :ph_edit_portfolio, owner: photographer
      end
      if photographer.save
        context.photographer = photographer
      else
        context.errors = photographer.errors.messages
        context.fail!
      end
    end
  end
end
