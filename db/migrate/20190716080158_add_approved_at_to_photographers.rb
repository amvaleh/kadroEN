class AddApprovedAtToPhotographers < ActiveRecord::Migration[5.0]
  def change
    add_column :photographers, :approved_at, :datetime
  end
end
