class AddTrackCodeToReceipts < ActiveRecord::Migration[5.0]
  def change
    add_column :receipts, :track_code, :string
  end
end
