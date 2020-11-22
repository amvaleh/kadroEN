class AddTimesToFeedbackChannel < ActiveRecord::Migration[5.0]
  def change
    add_column :feedback_channels, :times, :integer
  end
end
