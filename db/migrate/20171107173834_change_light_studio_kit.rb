class ChangeLightStudioKit < ActiveRecord::Migration[5.0]
  def change
    remove_column :equipments , :light_studio_kit
    add_column :equipments , :light_studio_kit , :boolean
  end
end
