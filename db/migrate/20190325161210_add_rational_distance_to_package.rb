class AddRationalDistanceToPackage < ActiveRecord::Migration[5.0]
  def change
    add_column :packages, :rational_distance, :float, default: 10
  end
end
