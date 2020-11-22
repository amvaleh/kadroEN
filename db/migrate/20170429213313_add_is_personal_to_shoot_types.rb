class AddIsPersonalToShootTypes < ActiveRecord::Migration[5.0]
  def change
    add_column :shoot_types, :is_personal, :boolean
  end
end
