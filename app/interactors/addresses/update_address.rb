module Addresses
  class UpdateAddress
    include Interactor

    def call
      address = Address.find_by(id: context.id)
      if address.present?
        address.lattitude = context.lattitude
        address.longtitude = context.longtitude
        address.input = context.input
        address.detail = context.detail
        address.save
        context.address = address
      else
        context.address = Addresses::CreateAddress.call(lattitude: context.lattitude, longtitude: context.longtitude, input: context.input, detail: context.detail).address
      end
    end
  end
end
