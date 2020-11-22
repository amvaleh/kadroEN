module Experiences
  class ExperienceCreate
    include Interactor

    def call
      experience = Experience.find_by(photographer_id: context.data[:photographer_id])
      photographer = Photographer.find(context.data[:photographer_id])
      if experience.present?
        experience.update_attributes(context.data)
        photographer.create_activity :ph_edit_experience, owner: photographer, recipient: experience
      else
        experience = Experience.new(years_been_photographer: context.data[:years_been_photographer],
                                    has_payed_work: context.data[:has_payed_work],
                                    projects_payed_count: context.data[:projects_payed_count],
                                    self_describe: context.data[:self_describe],
                                    bio: context.data[:bio],
                                    passion: context.data[:passion],
                                    love_job: context.data[:love_job],
                                    favorite_shoots: context.data[:favorite_shoots],
                                    shoots: context.data[:shoots],
                                    city_shoots: context.data[:city_shoots],
                                    awards: context.data[:awards],
                                    fun_fact: context.data[:fun_fact])
        experience.photographer = photographer
        if experience.save
          photographer.create_activity :ph_join_experience, owner: photographer, recipient: experience
          context.experience = experience
        else
          context.errors = location.errors.messages
          context.fail!
        end
      end
      is_full = true
      if experience.self_describe == nil or experience.bio == nil or experience.passion == nil or experience.love_job == nil or experience.favorite_shoots == nil or experience.shoots == nil or experience.city_shoots == nil or experience.awards == nil or experience.fun_fact == nil
        is_full = false
      end
      # TODO: must correct in other locations
      if photographer.join_step.code <= JoinStep.find_by_name("نمونه کارها").code && is_full
        photographer.join_step_id = JoinStep.find_by_name("تجربه کاری").id
      end
      context.experience = experience
      photographer.save
    end
  end
end
