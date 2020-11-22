class AddExtrahourTrackCodeToReceipts < ActiveRecord::Migration[5.0]
  def change
    add_column :receipts, :extrahour_track_code, :string
    add_column :receipts, :extra_paid, :boolean , default: true
  end
end
