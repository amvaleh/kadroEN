class UserFeedback < ApplicationRecord
  validates :project_id, presence: true
  validates :photographer_id, presence: true
  belongs_to :project
  belongs_to :photographer
  has_many :user_feedback_questions
  has_many :feedback_questions , through: :user_feedback_questions
end
