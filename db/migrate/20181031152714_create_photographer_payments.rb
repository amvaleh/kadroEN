class CreatePhotographerPayments < ActiveRecord::Migration[5.0]
  def change
    create_table :photographer_payments do |t|
      t.integer :photographer_id
      t.integer :project_id
      t.float :price
      t.integer :status
      t.integer :payment_type
      t.datetime :payment_date
      t.string :description

      t.timestamps
    end
    add_foreign_key(:photographer_payments, :photographers, column: :photographer_id, index: true)
    add_foreign_key(:photographer_payments, :projects, column: :project_id, index: true)
  end
end
