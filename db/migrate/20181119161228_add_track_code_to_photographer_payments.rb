class AddTrackCodeToPhotographerPayments < ActiveRecord::Migration[5.0]
  def change
    add_column(:photographer_payments, :track_code, :string)
    add_index(:photographer_payments, :track_code, unique: true)
  end
end
