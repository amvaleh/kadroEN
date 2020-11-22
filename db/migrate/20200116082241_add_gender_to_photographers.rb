class AddGenderToPhotographers < ActiveRecord::Migration[5.0]
  def change
    add_column :photographers, :gender, :integer
  end
end
