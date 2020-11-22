module Photographers::Analyze
  class MakeShootSuggestion
    include Interactor

    def call
      if !cookie_exists
        ShootSuggestion.create(photographer_id: context.photographer_id, project_id: context.project_id, user_id: context.user_id)
      end
    end

    def cookie_exists
      context.cookies[:visit].present?
    end
  end


end
