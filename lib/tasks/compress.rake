namespace :compress do
  desc "TODO"
  task newversion: :environment do
  Frames::RecreateVersion.call
end
end

