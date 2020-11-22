module Carts
  class AllItems
    include Interactor

    def call
      context.result = Item.joins(:item_type).select('items.*, item_types.category').
          order('item_types.seq, items.price')
    end
  end
end