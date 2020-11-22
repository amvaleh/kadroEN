class AddDescriptionToSettings < ActiveRecord::Migration[5.0]
  def change
    add_column :settings, :description, :text
  end
end
