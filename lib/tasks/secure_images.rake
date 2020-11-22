namespace :secure_images do
  desc "lets secure all image paths"
  task rename_all: :environment do
    visions = []
    puts "start"
    Frame.all.where(:public_id=> nil).order("created_at DESC").each do |frame|
      Frames::FixFrames.call(frame:frame)
    end
  end
end
