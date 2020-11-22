class AddShootDetailsToProject < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :shoot_detail, :text
  end
end
