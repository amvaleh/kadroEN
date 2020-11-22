class AddInStudioToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :in_studio, :boolean , default: false
  end
end
