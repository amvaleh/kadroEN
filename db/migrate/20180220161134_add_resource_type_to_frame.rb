class AddResourceTypeToFrame < ActiveRecord::Migration[5.0]
  def change
    add_column :frames, :resource_type, :string
    remove_column :frames, :format
    remove_column :frames, :type
  end
end
