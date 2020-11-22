class AddOrderToServiceSteps < ActiveRecord::Migration[5.0]
  def change
    add_column :service_steps, :order, :integer
  end
end
