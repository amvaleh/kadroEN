class AddStatusToItems < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :status, :integer
  end
end
