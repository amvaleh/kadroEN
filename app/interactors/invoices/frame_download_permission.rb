module Invoices
  class FrameDownloadPermission
    include Interactor

    def call
      frame_ids = Invoice.joins(invoice_items: :cart_item).
          joins('inner join carts c on c.id = cart_items.cart_id').
          joins('inner join items i on i.id = cart_items.item_id').
          joins('inner join item_types it on it.id = i.item_type_id').
          select('frame_id, user_id').
          where('invoices.id = ? and it.category = ?', context.invoice_id, 'download').map {|i| i.frame_id}
      Frame.where('id in (?)', frame_ids).update_all(downloaded: true)
    end
  end
end