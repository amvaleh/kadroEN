class AddEmailToPhotographers < ActiveRecord::Migration[5.0]
  def change
    add_column :photographers, :email, :string
    add_column :photographers, :static_number, :string
    add_column :photographers, :ideal_hours, :integer
  end
end
