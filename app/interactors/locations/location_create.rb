module Locations
  class LocationCreate
    include Interactor

    def call
      location = Location.new(living_address: context.data[:living_address],
                              living_long: context.data[:living_long],
                              living_lat: context.data[:living_lat],
                              working_long: context.data[:working_long],
                              working_lat: context.data[:working_lat],
                              living_input: context.data[:living_input],
                              working_input: context.data[:working_input])
      photographer = Photographer.find(context.data[:photographer_id])
      photographer.location = location
      if photographer.join_step.code <= JoinStep.find_by_name("اطلاعات اولیه").code
        photographer.join_step_id = JoinStep.find_by_name("اطلاعات مکانی").id
      end
      photographer.save
      if location.save
        context.location = location
      else
        context.errors = location.errors.messages
        context.fail!
      end
    end
  end
end
