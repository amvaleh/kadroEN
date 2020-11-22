class AddNameToGalleries < ActiveRecord::Migration[5.0]
  def change
    add_column :galleries, :name, :string
  end
end
