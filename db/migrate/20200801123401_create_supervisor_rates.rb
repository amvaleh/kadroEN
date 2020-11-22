class CreateSupervisorRates < ActiveRecord::Migration[5.0]
  def change
    create_table :supervisor_rates do |t|
      t.integer :admin_user_id
      t.integer :rate
      t.text :description
      t.integer :feed_back_id

      t.timestamps
    end
  end
end
