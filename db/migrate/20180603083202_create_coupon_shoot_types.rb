class CreateCouponShootTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :coupon_shoot_types do |t|
      t.integer :coupon_id, null: false
      t.integer :shoot_type_id, null: false
      t.timestamps
    end
  end
end
