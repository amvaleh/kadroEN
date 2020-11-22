module Projects
  class Update
    include Interactor

    def call
      project = Project.find_by(id: context.id)
      project = ProjectForm.new(project)
      if project.validate(context.data)
        project.save
        context.project = project
      else
        context.project = project
        context.fail!
      end
    end
  end
end