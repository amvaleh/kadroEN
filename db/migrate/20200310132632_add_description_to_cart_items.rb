class AddDescriptionToCartItems < ActiveRecord::Migration[5.0]
  def change
    add_column :cart_items, :description, :text
  end
end
