ActiveAdmin.register ProjectCandidate do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :project_id, :photographer_id, :project_candidate_status_id, :priority, :distance, :price
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  scope :payed

  #
  #
  #
  menu parent: "Project", priority: 5
  scope :confirmed
  scope :is_payed

  csv do
    column :id
    column "project slug" do |p|
      admin_project_url(p.project)
    end
    column "project slug" do |p|
      p.project.slug
    end
    column "photogrepher" do |p|
      admin_photographer_url(p.photographer)
    end
    column "photogrepher" do |p|
      p.photographer.display_name
    end
    column "shoot type" do |p|
      p.project.shoot_type.title
    end
    column "project candidate status" do |p|
      p.project_candidate_status.title
    end
    column :priority
    column :distance
    column :price
    column "project reservee step" do |p|
      p.project.reserve_step.name
    end
    column "project duration" do |p|
      p.project.package.duration
    end
    column "project is payed" do |p|
      p.project.is_payed
    end
  end

  index do
    selectable_column
    column :id
    column :project
    column :photographer
    column :project_candidate_status
    column :priority
    column :distance
    column :price
    column "project reservee step" do |p|
      p.project.reserve_step.name
    end

    column "project duration" do |p|
      p.project.package.duration
    end

    column "project is payed" do |p|
      p.project.is_payed
    end
    column :reason_for_reject
    actions
  end

  filter :project, as: :select, collection: Project.payed.sort_by { |p| p.slug }.map { |u| [u.slug, u.id] }
  filter :photographer, as: :select, collection: Photographer.approved.sort_by { |p| p.id }.map { |u| [u.display_name, u.id] }
  filter :project_candidate_status
  filter :priority
  filter :distance
  filter :price
  filter :created_at
  filter :updated_at
  filter :assigned_at
end
