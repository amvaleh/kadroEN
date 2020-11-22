class AddPayAuthorityToInvoices < ActiveRecord::Migration[5.0]
  def change
    add_column :invoices, :authority, :string
  end
end
