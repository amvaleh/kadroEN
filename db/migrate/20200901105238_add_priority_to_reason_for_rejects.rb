class AddPriorityToReasonForRejects < ActiveRecord::Migration[5.0]
  def change
    add_column :reason_for_rejects, :priority, :integer
  end
end
