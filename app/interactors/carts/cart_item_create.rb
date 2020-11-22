module Carts
  class CartItemCreate
    include Interactor

    def call
      project_id = Gallery.joins(:frames).
          where('frames.id = ?', context.cart_item_data[:frame_id]).
          pluck(:project_id)[0]
      current_cart_item = CartItem.find_by(item_id: context.cart_item_data[:item_id],
                                           cart_id: context.cart_item_data[:cart_id],
                                           frame_id: context.cart_item_data[:frame_id])
      cart_item =
          if current_cart_item
            CartItemForm.new(current_cart_item)
          else
            CartItemForm.new(CartItem.new)
          end

      if cart_item.validate(context.cart_item_data.merge(project_id: project_id))
        cart_item.save
      else
        context.cart_item = cart_item
        context.fail!
      end
    end
  end
end