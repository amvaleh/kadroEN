module FreeTimes
  class CreateOptimumFreeTime
    include Interactor
    include ApplicationHelper
    def call
      @photographer = context.photographer
      projects = Project.confirmed.joins(:shoot_type => :photographers).
          where(:photographers=>{:id=> @photographer.id})
      context.projects = projects
    end
  end
end
