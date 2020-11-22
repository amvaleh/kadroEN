class AddSizeOfPrintToItems < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :width, :integer
    add_column :items, :height, :integer
  end
end
