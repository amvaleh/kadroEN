class AddRecommendedHoursToShootTypes < ActiveRecord::Migration[5.0]
  def change
    add_column :shoot_types, :recommended_hours, :float , default: 2
  end
end
