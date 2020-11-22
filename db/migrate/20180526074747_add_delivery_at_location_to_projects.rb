class AddDeliveryAtLocationToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :delivery_at_location, :boolean , default: false
  end
end
