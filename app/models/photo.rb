class Photo < ApplicationRecord

  validates :file, presence: true

  mount_uploader :file, PhotoUploader

  belongs_to :expertise

  has_many :selectable_images, as: :image

  has_many :images , through: :selectable_images
  
  belongs_to :exif

  before_destroy :delete_exif, :expertise_update

  after_update :expertise_update

  def expertise_update
    self.expertise.update(:updated_at => Time.now)
  end


  def delete_exif
    self.exif.destroy if self.exif.present?
  end

  def to_jq_upload
    {
      "name" => read_attribute(:file),
      "size" => file.size,
      "url" => file.url(:thumb),
      "delete_url" => "/photos/#{id}",
      "delete_type" => "DELETE"
    }
  end

end
