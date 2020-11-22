module Carts
  class CartUpdate
    include Interactor

    def call
      cart_parent = CartParentCreate.call(user: context.user,
                                          cart_data: {user_id: context.user.id, status: 0})

      current_cart_item = CartItem.find_by(item_id: context.cart_item_data[:item_id],
                                           cart_id: cart_parent.cart.id,
                                           frame_id: context.cart_item_data[:frame_id])
      cart_item = CartItemForm.new(current_cart_item)
      if cart_item.validate(context.cart_item_data)
        cart_item.save
      else
        context.cart_item = cart_item
        context.fail!
      end
    end
  end
end