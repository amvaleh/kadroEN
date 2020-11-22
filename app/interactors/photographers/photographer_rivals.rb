module Photographers
  class PhotographerRivals
    include Interactor

    def call
      context.photographers = Photographer.joins(:project_candidates).where('project_candidates.project_id in (?)', context.ids).select('photographers.*, project_candidates.project_id, project_candidates.price')
    end
  end
end