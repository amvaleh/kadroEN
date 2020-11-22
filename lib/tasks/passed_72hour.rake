desc 'Passed 72 Hour For Project'
task passed_72hour: :environment do
  # @projects = Project.where(:reserve_step_id=>ReserveStep.find_by(name:"confirmed").id)
  projects = Project.where('is_payed = ? and confirmed = ? and start_time is not null', true, true).load
  projects.each do |project|
    time = project.start_time
    # if (Time.now - time) > 72.hours
    if ((Time.now - time.in_time_zone('Tehran')) / 3600) > 72
      project.update_attributes(:passed_72hour => true)
    end
  end
end
