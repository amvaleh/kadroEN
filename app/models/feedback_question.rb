class FeedbackQuestion < ApplicationRecord
  has_many :user_feedback_questions
  has_many :user_feedbacks , through: :user_feedback_questions
  after_create :generate_name

  scope :photographer_questions , -> {
    where(:question_type => "photographer", :active=>true)
  }

  def generate_name
    self.name = "question_#{self.id}"
    self.save
  end
end
