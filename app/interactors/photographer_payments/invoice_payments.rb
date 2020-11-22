module PhotographerPayments
  class InvoicePayments
    include Interactor

    def call
      invoices = Invoice.joins(invoice_items: :cart_item).
          joins('inner join carts c on c.id = cart_items.cart_id').
          joins('inner join items i on i.id = cart_items.item_id').
          joins('inner join projects p on p.id = cart_items.project_id').
          joins('inner join item_types it on it.id = i.item_type_id').
          joins('left join commissions com on com.id = it.commission_id').
          select('invoices.*, invoice_items.price, invoice_items.quantity, cart_items.project_id, p.photographer_id, it.category, com.value commission_value, com.value_type').
          where(id: context.invoice_id).load

      invoices.group_by(&:project_id).each do |project_id, value|
        price = 0
        photographer_id = 0
        value.each do |invoice|
          commission_value = invoice.commission_value
          value_type = Lookup.find_by(category: 'value_type', code: invoice.value_type).title
          if value_type == 'درصدی'
            price = (price.to_i + (invoice.price.to_i * commission_value / 100)).to_i.to_s
          elsif value_type == 'مبلغی'
            price = (price.to_i + commission_value * invoice.quantity).to_i.to_s
          end

          photographer_id = invoice.photographer_id
        end

        PhotographerPayments::PhotographerPaymentCreate.call(data: {photographer_id: photographer_id,
                                                                    project_id: project_id,
                                                                    price: price,
                                                                    status: 2,
                                                                    payment_type: 3,
                                                                    invoice_id: context.invoice_id}) if price.to_i > 0
      end
    end
  end
end