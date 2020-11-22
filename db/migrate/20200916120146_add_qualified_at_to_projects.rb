class AddQualifiedAtToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :qualified_at, :datetime
  end
end
