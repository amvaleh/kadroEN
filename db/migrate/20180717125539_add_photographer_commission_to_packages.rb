class AddPhotographerCommissionToPackages < ActiveRecord::Migration[5.0]
  def change
    add_column :packages, :photographer_commission, :integer , default: 0
  end
end
