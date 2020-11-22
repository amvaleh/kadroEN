module Photographers
  class MessageForLackOfCooperation
    include Interactor

    def call
      photographer = Photographer.find_by(id: context.photographer_id)
      EmailForLackOfCooperation.perform_async(photographer.id)
    end
  end
end