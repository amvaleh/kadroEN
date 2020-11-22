class CreateServiceSteps < ActiveRecord::Migration[5.0]
  def change
    create_table :service_steps do |t|
      t.string :title

      t.timestamps
    end
  end
end
