class UserFeedbackQuestion < ApplicationRecord
  belongs_to :feedback_question
  belongs_to :user_feedback

  validates_numericality_of :value , :less_than => 11 , :greater_than => -1
end
