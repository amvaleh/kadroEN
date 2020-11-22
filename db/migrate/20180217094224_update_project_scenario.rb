class UpdateProjectScenario < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :is_shooted, :boolean , default: false
    add_column :projects, :is_uploaded, :boolean , default: false
    add_column :projects, :checked_out, :boolean , default: false
    add_column :projects, :send_coustomer, :boolean , default: false
    add_column :projects, :passed_72hour, :boolean , default: false
    add_column :projects, :extend_hours, :integer , default: 0
    add_column :projects, :print_order, :integer , default: 0
    add_column :projects, :extera_download, :integer , default: 0

  end
end
