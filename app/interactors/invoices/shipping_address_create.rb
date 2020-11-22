module Invoices
  class ShippingAddressCreate
    include Interactor

    def call
      address_form = AddressForm.new(Address.new)
      if address_form.validate(context.data)
        address_form.save
        context.address = address_form
      else
        context.address = address_form
        context.fail!
      end
    end
  end
end