module Carts
  class CartCreate
    include Interactor

    def call
      # Rw::Authorize.call(context.user, CartPolicy, :create?)
      cart_parent = CartParentCreate.call(user: context.user,
                            cart_data: {user_id: context.user.id, status: 0})
      CartItemCreate.call(cart_item_data: context.cart_item_data.merge(cart_id: cart_parent.cart.id))
    end
  end
end
