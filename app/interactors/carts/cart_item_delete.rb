module Carts
  class CartItemDelete
    include Interactor

    def call
      cart_item = CartItem.find_by(id: context.cart_item_id)
      Rw::Authorize.call(context.user, CartItemPolicy, :cart_item_delete?, cart_item)
      ActiveRecord::Base.transaction do
        InvoiceItem.where(cart_item_id: context.cart_item_id).delete_all
        CartItem.where(id: context.cart_item_id).delete_all
      end
    end
  end
end