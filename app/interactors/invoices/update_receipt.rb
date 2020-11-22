module Invoices
  class UpdateReceipt
    include Interactor

    def call
      invoice_items = InvoiceItem.joins(cart_item: :item).
          joins('inner join item_types it on it.id = items.item_type_id').
          joins('left join commissions c on c.id = it.commission_id').
          select('cart_items.project_id, invoice_items.price, it.category, invoice_items.quantity, c.value commission_value, c.value_type').
          where(invoice_id: context.invoice_id).load

      invoice_items.each do |item|
        receipt = Receipt.joins(:project).select('receipts.*, projects.print_order, projects.id project_id, extra_download').
            where('projects.id = ?', item.project_id).take(1)[0]

        commission_value = item.commission_value

        value_type = Lookup.find_by(category: 'value_type', code: item.value_type).title
        if value_type == 'درصدی'
          ph_payment = (receipt.ph_payment.to_i + (item.price.to_i * commission_value / 100)).to_i.to_s
        elsif value_type == 'مبلغی'
          ph_payment = (receipt.ph_payment.to_i + commission_value).to_i.to_s
        end
        Receipts::Update.call(id: receipt.id,
                              data: {total: (receipt.total.to_i + item.price.to_i).to_s,
                                     subtotal: (receipt.subtotal.to_i + item.price.to_i).to_s,
                                     ph_payment: ph_payment
                              })
        if item.category == 'download'
          Projects::Update.call(id: receipt.project_id,
                                data: {extra_download: (receipt.extra_download + item.quantity)})
          Receipts::Update.call(id: receipt.id, data: {filedownload_total: receipt.filedownload_total + item.price.to_i})
        elsif item.category != 'service'
          Projects::Update.call(id: receipt.project_id,
                                data: {print_order: (receipt.print_order + item.quantity)})
          Receipts::Update.call(id: receipt.id, data: {print_total: receipt.print_total + item.price.to_i})
        end
      end
    end
  end
end
