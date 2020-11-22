module Carts
  class CartClear
    include Interactor

    def call
      ActiveRecord::Base.transaction do
        cart = Cart.find_by('carts.user_id = ? and status = 0', context.user.id)
        invoice_id = Invoice.joins(invoice_items: :cart_item).
            joins('inner join carts c on c.id = cart_items.cart_id').
            joins('inner join items i on i.id = cart_items.item_id').
            where('cart_items.cart_id = ?', cart.id).pluck(:id)
        InvoiceItem.where(invoice_id: invoice_id).delete_all
        Invoice.where(id: invoice_id).delete_all

        CartItem.where(cart_id: cart.id).delete_all
        cart.delete
      end
    end
  end
end