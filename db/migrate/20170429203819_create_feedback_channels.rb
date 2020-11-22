class CreateFeedbackChannels < ActiveRecord::Migration[5.0]
  def change
    create_table :feedback_channels do |t|
      t.string :title

      t.timestamps
    end
  end
end
