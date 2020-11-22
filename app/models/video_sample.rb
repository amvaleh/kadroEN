class VideoSample < ApplicationRecord
  mount_uploader :video_source, VideoUploader
  validates :eng_title, :presence => true
  validates_uniqueness_of :eng_title, :message => "نام انگلیسی باید یکتا باشد."
  mount_uploader :video_poster, AvatarUploader

end
