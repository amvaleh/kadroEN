class AddDescriptionToServiceSteps < ActiveRecord::Migration[5.0]
  def change
    add_column :service_steps, :description, :text
  end
end
