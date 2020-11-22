class CreateInvoiceFactors < ActiveRecord::Migration[5.0]
  def change
    create_table :invoice_factors do |t|
      t.integer :invoice_id
      t.integer :factor_id
      t.float :value

      t.timestamps
    end
  end
end
