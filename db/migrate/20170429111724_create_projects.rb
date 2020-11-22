class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.date :start_date
      t.integer :start_hour_id
      t.integer :week_day_id
      t.integer :photographer_id
      t.integer :shoot_type_id
      t.integer :package_id
      t.integer :coupon_id
      t.integer :user_id
      t.integer :receipt_id
      t.integer :address_id

      t.timestamps
    end
  end
end
