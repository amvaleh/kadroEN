module Addresses
  class CreateAddress
    include Interactor

    def call
      context.address = Address.create(lattitude: context.lattitude, longtitude: context.longtitude, input: context.input, detail: context.detail)
    end
  end
end
