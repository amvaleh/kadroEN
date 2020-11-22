class AddIsFullToPackages < ActiveRecord::Migration[5.0]
  def change
    add_column :packages, :is_full, :boolean
  end
end
