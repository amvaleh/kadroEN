module Projects
  class CalculateExtraHours
    include Interactor

    def call
      project = Project.find(context.project_id)
      context.hours_added = project.extra_hour_requested
      context.cost_to_add = project.shoot_type.half_hour_extend_cost * (project.extra_hour_requested * 2)
      if project.package.is_full
        context.new_frames = 0
      else
        context.new_frames = (project.package.digitals / 2) * (project.extra_hour_requested * 2)
      end
    end
  end
end
