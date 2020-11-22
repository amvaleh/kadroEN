class AddDefaultToChangeLoopTimes < ActiveRecord::Migration[5.0]
  def change
    change_column_default :projects, :change_loop_times, 0
  end
end
