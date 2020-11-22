class AddReferencesForAllTables < ActiveRecord::Migration[5.0]
  def change
    # projects
    # add_foreign_key :projects,:addresses
    # add_foreign_key :projects,:receipts
    # add_foreign_key :projects,:start_hours
    # add_foreign_key :projects,:feedback_channels
    # add_foreign_key :projects,:packages
    # add_foreign_key :projects,:week_days
    # add_foreign_key :projects,:photographers
    # add_foreign_key :projects,:shoot_types
    # add_foreign_key :projects,:coupons
    # add_foreign_key :projects,:users
    # add_index :projects,:address_id
    # add_index :projects,:receipt_id
    # add_index :projects,:start_hour_id
    # add_index :projects,:feedback_channel_id
    # add_index :projects,:package_id
    # add_index :projects,:week_day_id
    # add_index :projects,:photographer_id
    # add_index :projects,:shoot_type_id
    # add_index :projects,:coupon_id
    # add_index :projects,:user_id
    #
    #
    # # equip_cameras
    # add_foreign_key :equip_cameras,:cameras
    # add_foreign_key :equip_cameras,:equipments
    # add_index :equip_cameras,:camera_id
    # add_index :equip_cameras,:equipment_id
    #
    # # equip_lenzs
    # add_foreign_key :equip_lenzs,:lenzs
    # add_foreign_key :equip_lenzs,:equipments
    # add_index :equip_lenzs,:lenz_id
    # add_index :equip_lenzs,:equipment_id
    #
    # # equipments
    # add_foreign_key :equipments,:photographers
    # add_index :equipments,:photographer_id
    #
    # # experiences
    # add_foreign_key :experiences,:photographers
    # add_index :experiences,:photographer_id
    #
    # # expertises
    # add_foreign_key :expertises,:shoot_types
    # add_foreign_key :expertises,:photographers
    # add_index :expertises,:shoot_type_id
    # add_index :expertises,:photographer_id
    #
    # # friendly_id_slugs
    # # add_foreign_key :friendly_id_slugs,:sluggables
    # # add_index :friendly_id_slugs,:sluggable_id
    #
    # # packages
    # add_foreign_key :packages,:shoot_types
    # add_index :packages,:shoot_type_id
    #
    # # photographers
    # add_foreign_key :photographers,:join_steps
    # add_foreign_key :photographers,:locations
    # add_index :photographers,:join_step_id
    # add_index :photographers,:location_id
    #
    # # photos
    # add_foreign_key :photos,:expertises
    # add_index :photos,:expertise_id
    #
    # # receipts
    # add_foreign_key :receipts,:coupons
    # add_foreign_key :receipts,:users
    # add_index :receipts,:coupon_id
    # add_index :receipts,:user_id
    #
    # # shoot_types
    # add_foreign_key :shoot_types,:expertises
    # add_index :shoot_types,:expertise_id
    #
    # # start_hours
    # add_foreign_key :start_hours,:day_times
    # add_foreign_key :start_hours,:week_days
    # add_index :start_hours,:day_time_id
    # add_index :start_hours,:week_day_id
    #
  end
end
