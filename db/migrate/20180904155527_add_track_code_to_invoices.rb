class AddTrackCodeToInvoices < ActiveRecord::Migration[5.0]
  def change
    add_column :invoices, :track_code, :string
  end
end
