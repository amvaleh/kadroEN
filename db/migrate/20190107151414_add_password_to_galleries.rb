class AddPasswordToGalleries < ActiveRecord::Migration[5.0]
  def change
    add_column :galleries, :salt, :string
    add_column :galleries, :hashed_password, :string
  end
end
