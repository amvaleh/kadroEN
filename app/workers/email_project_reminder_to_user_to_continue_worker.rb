class EmailProjectReminderToUserToContinueWorker
  include Sidekiq::Worker

  def perform(project_id)
    project = Project.find(project_id)
    case project.reserve_step.name
    when('package')
      ProjectMailer.reminder_for_package_step(project_id).deliver_now
    when('location')
      ProjectMailer.reminder_for_location_step(project_id).deliver_now
    when('date')
      ProjectMailer.reminder_for_date_step(project_id).deliver_now
    when('photographer')
      ProjectMailer.reminder_for_photographer_step(project_id).deliver_now
    when('canceled_payment')
      ProjectMailer.reminder_for_canceled_payment_step(project_id).deliver_now
    end
  end
end
