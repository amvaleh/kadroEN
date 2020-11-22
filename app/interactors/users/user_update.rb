module Users
  class UserUpdate
    include Interactor

    def call
      user_form = UserForm.new(User.find_by(id: context.id))
      if user_form.validate(context.user_data)
        user_form.save
        context.user = user_form
      else
        context.user = user_form
        context.fail!
      end
    end
  end
end