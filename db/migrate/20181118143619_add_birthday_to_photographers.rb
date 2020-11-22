class AddBirthdayToPhotographers < ActiveRecord::Migration[5.0]
  def change
    add_column :photographers, :birthday, :datetime
  end
end
