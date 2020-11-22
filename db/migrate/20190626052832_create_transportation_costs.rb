class CreateTransportationCosts < ActiveRecord::Migration[5.0]
  def change
    create_table :transportation_costs do |t|
      t.boolean :active
      t.integer :receipt_id

      t.timestamps
    end
  end
end
