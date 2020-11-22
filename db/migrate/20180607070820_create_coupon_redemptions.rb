class CreateCouponRedemptions < ActiveRecord::Migration[5.0]
  def change
    create_table :coupon_redemptions do |t|
      t.belongs_to :coupon, null: false
      t.integer :user_id, null: true
      t.integer :receipt_id, null: true
      t.timestamps null: false
    end
  end
end
