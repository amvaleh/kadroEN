class AddChangeDateTimesToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :change_date_times, :integer
  end
end
