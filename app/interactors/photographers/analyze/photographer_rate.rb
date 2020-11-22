module Photographers::Analyze
  class PhotographerRate
    include Interactor

    def call
      context.arate = Project.joins(:feed_back)
                          .where('photographer_id = ?', context.photographer_id).average('arate')
      context.qrate = Project.joins(:feed_back)
                          .where('photographer_id = ?', context.photographer_id).average('qrate')
    end
  end
end
