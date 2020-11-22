class GoodFeedback < ActiveRecord::Base
  self.primary_key = :feed_back_id

  def readonly?
    true
  end
end
