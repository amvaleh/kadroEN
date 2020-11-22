class SendGalleryLinkWorker
  include Sidekiq::Worker

  def perform(project_id)
    project = Project.find(project_id)
    ProjectMailer.send_gallery_link(project_id).deliver_now
  end
end
