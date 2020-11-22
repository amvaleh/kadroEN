class CreateCreditDetailTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :credit_detail_types do |t|
      t.string :name
      t.timestamps
    end
  end
end
