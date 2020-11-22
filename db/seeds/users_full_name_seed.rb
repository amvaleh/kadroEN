User.all.each do |user|
  if user.full_name.blank?
    user.full_name = user.first_name.to_s + " " + user.last_name.to_s
    user.save
  end
end