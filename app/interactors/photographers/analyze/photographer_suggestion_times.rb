module Photographers::Analyze
  class PhotographerSuggestionTimes
    include Interactor
    def call
      context.suggestion_times = ShootSuggestion.where('photographer_id = ?', context.photographer_id).count
    end
  end
end
