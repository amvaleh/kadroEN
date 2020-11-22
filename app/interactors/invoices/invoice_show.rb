module Invoices
  class InvoiceShow
    include Interactor

    def call
      invoice = Invoice.find_by(track_code: context.track_code)
      Rw::Authorize.call(context.user, InvoicePolicy, :invoice_show?, invoice)

      context.result = Invoice.joins(invoice_items: :cart_item).
          joins('inner join carts c on c.id = cart_items.cart_id').
          joins('inner join items i on i.id = cart_items.item_id').
          select('invoices.*, unit_price, invoice_items.price, invoice_items.quantity, frame_id, user_id, i.title').
          where(track_code: context.track_code).load
    end
  end
end