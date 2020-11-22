module Photographers
  class CheckPhotographerJoinStep
    include Interactor

    def call
      photographer_id = context.photographer_id

      photographer = Photographer.find(photographer_id)
      if photographer.join_step.name == 'پروفایل ناقص' or photographer.join_step.name == 'تایید اما ناقص'
        photographer.join_step_id = JoinStep.find_by(name: 'بازنگری').id
        photographer.save
      end
    end
  end
end