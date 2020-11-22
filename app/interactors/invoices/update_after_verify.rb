module Invoices
  class UpdateAfterVerify
    include Interactor

    def call
      Invoices::InvoiceUpdate.call(id: context.invoice.id,
                                   invoice_data: {track_code: context.ref_id, status: 1})
      current_cart = Carts::CurrentCartItems.call(user: context.user).result
      cart = CartForm.new(Cart.find_by(id: current_cart[0].cart_id))
      if cart.validate(status: 1)
        cart.save
      end
    end
  end
end