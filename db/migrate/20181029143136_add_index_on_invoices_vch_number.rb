class AddIndexOnInvoicesVchNumber < ActiveRecord::Migration[5.0]
  def change
    add_index(:invoices, :vch_number, unique: true)
  end
end
