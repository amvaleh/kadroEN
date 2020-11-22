class AddNumberOfRepetitions < ActiveRecord::Migration[5.0]
  def change
    add_column :coupons, :number_of_repetitions, :integer, null: false, default: 1
  end
end
