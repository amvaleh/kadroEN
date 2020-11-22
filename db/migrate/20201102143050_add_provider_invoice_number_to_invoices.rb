class AddProviderInvoiceNumberToInvoices < ActiveRecord::Migration[5.0]
  def change
    add_column :invoices, :provider_invoice_number, :string
  end
end
