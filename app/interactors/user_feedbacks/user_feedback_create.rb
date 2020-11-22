module UserFeedbacks
  class UserFeedbackCreate
    include Interactor

    def call
      user_feedback = UserFeedback.create!(project: context.project, photographer: context.project.photographer, description: context.data[:user_feedback][:description])
      context.data[:user_feedback_question].each do |question|
        value = context.data[:user_feedback_question][question]
        feedback_question = FeedbackQuestion.find_by_name(question)
        user_feedback_question = UserFeedbackQuestion.new(:feedback_question_id => feedback_question.id, :user_feedback_id => user_feedback.id, :value => value)
        user_feedback_question.save
      end
      if user_feedback.save
        context.user_feedback = user_feedback
      else
        context.errors = user_feedback.errors.messages
        context.fail!
      end
    end
  end
end
