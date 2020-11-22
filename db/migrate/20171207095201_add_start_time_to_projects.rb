class AddStartTimeToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :start_time, :datetime
    connection.execute('update projects set start_time = start_date')
  end
end
