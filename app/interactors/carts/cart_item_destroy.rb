module Carts
  class CartItemDestroy
    include Interactor

    def call
      Rw::Authorize.call(context.user, CartPolicy, :destroy_cart?)
      CartItem.where('id in (?)', context.ids).delete_all
    end
  end
end