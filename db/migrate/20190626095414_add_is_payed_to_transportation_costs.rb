class AddIsPayedToTransportationCosts < ActiveRecord::Migration[5.0]
  def change
    add_column :transportation_costs, :is_payed, :boolean
  end
end
