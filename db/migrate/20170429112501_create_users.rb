class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :mobile_number
      t.string :first_name
      t.string :last_name
      t.string :company_name

      t.timestamps
    end
  end
end
