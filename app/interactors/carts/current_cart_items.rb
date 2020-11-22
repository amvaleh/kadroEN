module Carts
  class CurrentCartItems
    include Interactor

    def call
      if context.user
        context.result = CartItem.joins(:cart).joins(item: :item_type).
            select('cart_items.*,items.title,items.price, item_types.category').
            where('carts.user_id = ? and carts.status = 0 and quantity <> 0', context.user.id).
            order('item_types.seq')
      elsif context.cart_id
        context.result = CartItem.joins(:cart).joins(item: :item_type).
            joins("left join lookups l on l.code = carts.status and l.category = 'shop_status'").
            select('cart_items.*,items.title,items.price,item_types.category, carts.status, l.title status_title').
            where('carts.id = ? and quantity <> 0', context.cart_id).
            order('item_types.seq')
      end
    end
  end
end