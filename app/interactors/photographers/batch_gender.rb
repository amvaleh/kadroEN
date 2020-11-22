module Photographers
  class BatchGender
    include Interactor

    def call
      context.ids.each do |id|
        photographer = Photographer.find_by_id(id)
        if context.gender == "male"
          gender = 2
        elsif context.gender == "female"
          gender = 1
        end
        photographer.gender = gender
        photographer.save
      end
    end
  end
end
