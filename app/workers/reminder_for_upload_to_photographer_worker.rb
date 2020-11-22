class ReminderForUploadToPhotographerWorker
  include Sidekiq::Worker

  def perform(project_id)
    project = Project.find(project_id)
      ProjectMailer.reminder_for_upload_to_photographer(project_id).deliver_now
  end
end
