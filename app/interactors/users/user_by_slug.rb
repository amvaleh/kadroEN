module Users
  class UserBySlug
    include Interactor

    def call
      context.result = User.friendly.find(context.slug)
    end
  end
end