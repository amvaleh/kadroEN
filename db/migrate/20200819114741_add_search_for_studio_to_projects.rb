class AddSearchForStudioToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :search_for_studio, :boolean , default: false
  end
end
