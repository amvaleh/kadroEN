class AddSamplesToShootTypes < ActiveRecord::Migration[5.0]
  def change
    add_column :shoot_types, :samples, :json
  end
end
