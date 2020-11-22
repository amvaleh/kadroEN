module Invoices
  class ShopOrderDetails
    include Interactor

    def call
      invoices = Invoice.joins(invoice_items: :cart_item).joins('inner join items i on i.id = cart_items.item_id').joins('inner join item_types it on it.id = i.item_type_id').joins('inner join commissions co on co.id = it.commission_id')
                     .joins('inner join projects p on p.id = cart_items.project_id')
                     .select('invoice_items.price, invoice_items.id invoice_item_id, co.value commission_value, co.value_type commission_type, p.photographer_id').where(id: context.invoice_id).load

      invoices.each do |invoice|
        commission_value = invoice.commission_value

        if invoice.commission_type == 2
          price = (invoice.price.to_i * commission_value / 100).to_i.to_s
        elsif invoice.commission_type == 1
          price = commission_value.to_i.to_s
        end

        unless price == "0"
          Invoices::ShopOrderDetailCreate.call(data: {
              photographer_id: invoice.photographer_id,
              invoice_item_id: invoice.invoice_item_id,
              subtotal: price
          })
        end
      end
    end
  end
end