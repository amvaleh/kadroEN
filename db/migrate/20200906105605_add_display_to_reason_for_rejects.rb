class AddDisplayToReasonForRejects < ActiveRecord::Migration[5.0]
  def change
    add_column :reason_for_rejects, :display, :boolean, default: true
  end
end
