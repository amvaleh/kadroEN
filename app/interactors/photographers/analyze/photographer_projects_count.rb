module Photographers::Analyze
  class PhotographerProjectsCount
    include Interactor
    def call
      context.projects_number = Project.payed.where('photographer_id = ?', context.photographer_id).count
    end
  end
end