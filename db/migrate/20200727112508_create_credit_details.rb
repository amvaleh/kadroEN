class CreateCreditDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :credit_details do |t|
      t.integer :value
      t.integer :credit_id
      t.integer :project_id
      t.integer :credit_detail_type_id
      t.timestamps
    end
  end
end
