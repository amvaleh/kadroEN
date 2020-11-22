class AddJoinStepIdToPhotographers < ActiveRecord::Migration[5.0]
  def change
    add_column :photographers, :join_step_id, :integer , default: 0
  end
end
