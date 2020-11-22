class AddFeedbackChannelIdToProject < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :feedback_channel_id, :integer
  end
end
