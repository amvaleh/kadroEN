class ChangeInvoiceIdToInvoiceItemId < ActiveRecord::Migration[5.0]
  def change
    rename_column :invoice_factors, :invoice_id, :invoice_item_id
  end
end
