class UpdateGoodFeedbacksToVersion2 < ActiveRecord::Migration[5.0]
  def change
    update_view :good_feedbacks, version: 2, revert_to_version: 1
  end
end
