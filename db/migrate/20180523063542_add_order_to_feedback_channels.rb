class AddOrderToFeedbackChannels < ActiveRecord::Migration[5.0]
  def change
    add_column :feedback_channels, :order, :integer
  end
end
