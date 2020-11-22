class CreateGoodFeedbacks < ActiveRecord::Migration[5.0]
  def change
    create_view :good_feedbacks
  end
end
