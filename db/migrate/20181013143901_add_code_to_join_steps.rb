class AddCodeToJoinSteps < ActiveRecord::Migration[5.0]
  def change
    add_column(:join_steps, :code, :integer)
  end
end
