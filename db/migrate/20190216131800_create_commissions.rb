class CreateCommissions < ActiveRecord::Migration[5.0]
  def change
    create_table :commissions do |t|
      t.string :title
      t.float :value
      t.integer :value_type

      t.timestamps
    end
  end
end
