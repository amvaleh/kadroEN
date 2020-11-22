Project.where(first_call: true).each do |project|
  project.call_status_id = CallStatus.find_by(title: 'called').id
  project.save
end