class AddValueToTransportationCosts < ActiveRecord::Migration[5.0]
  def change
    add_column :transportation_costs, :value, :float, default: 0
  end
end
