module Photographers
  class PhotographerCreate
    include Interactor

    def call
      photographer = Photographer.where(id: context.data[:id]).take(1)[0]
      if photographer.nil?
        photographer = Photographer.new(first_name: context.data[:first_name],
                                        last_name: context.data[:last_name],
                                        mobile_number: context.data[:mobile_number],
                                        password: context.data[:password],
                                        static_number: context.data[:static_number],
                                        ideal_hours: context.data[:ideal_hours],
                                        email: context.data[:email])
        photographer.join_step_id = JoinStep.find_by_name("اطلاعات اولیه").id
      else
        photographer.first_name = context.data[:first_name]
        photographer.last_name = context.data[:last_name]
        photographer.mobile_number = context.data[:mobile_number]
        photographer.password = context.data[:password]
        photographer.static_number = context.data[:static_number]
        photographer.ideal_hours = context.data[:ideal_hours]
        photographer.email = context.data[:email]
      end

      if context.data[:parent_id].present?
        parent = Photographer.find_by_uid(context.data[:parent_id])
        if parent.present?
          photographer.parent = parent
        end
      end
      if photographer.save
        photographer.create_activity :ph_join_prime_info, owner: photographer
        context.photographer = photographer
      else
        context.errors = photographer.errors.messages
        context.fail!
      end
    end
  end
end
