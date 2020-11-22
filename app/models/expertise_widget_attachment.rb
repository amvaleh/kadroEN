class ExpertiseWidgetAttachment < ApplicationRecord
  belongs_to :expertise_widget
  mount_uploader :photo, ScannedProfileUploader
  validates :photo, presence: true

  def to_jq_upload
    {
      "name" => read_attribute(:photo),
      "size" => photo.size,
      "url" => photo.url(:medium),
      "delete_url" => "/photos/#{id}",
      "delete_type" => "DELETE"
    }
  end
end
