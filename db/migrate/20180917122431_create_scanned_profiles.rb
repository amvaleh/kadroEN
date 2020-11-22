class CreateScannedProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :scanned_profiles do |t|
      t.string :birthـcertificate
      t.string :national_card
      t.integer :photographer_id
      t.timestamps
    end
    add_foreign_key(:scanned_profiles, :photographers, column: :photographer_id, index: true)
  end
end
