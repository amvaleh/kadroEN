class ChangeExtendHoursType < ActiveRecord::Migration[5.0]
  def change
    change_column :projects, :extend_hours, :float , default: 0
  end
end
