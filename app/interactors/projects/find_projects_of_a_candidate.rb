module Projects
  class FindProjectsOfACandidate
    include Interactor

    def call
      photographer_id = context.photographer_id
      from = context.from
      show_number = context.show_number
      projects = Project.confirmed.a_month_ago.joins(:project_candidates).where('project_candidates.photographer_id = ?', photographer_id).joins(:reserve_step).where('reserve_steps.id > ?', ReserveStep.find_by(name: "photographer").id).order(start_time: :desc)
      context.size = projects.size
      context.projects = projects[from..(from + show_number)]
    end
  end
end
