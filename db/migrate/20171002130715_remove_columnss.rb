class RemoveColumnss < ActiveRecord::Migration[5.0]
  def change
    remove_column :photographers, :location
  end
end
