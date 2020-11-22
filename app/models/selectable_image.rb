class SelectableImage < ApplicationRecord
  belongs_to :image, polymorphic: true
  has_many :selectable_image_shoot_types
  has_one :shoot_type, through: :selectable_image_shoot_types
  after_save :check_published

  def check_published
    if self.dislike_number_changed?
      if ((self.like_number * 2) < dislike_number) && (dislike_number > 10)
        self.published = false
        self.save
      end
    end
  end

  def file_url_address
    if self.image_type == "Frame"
      if Frame.find_by_id(self.image_id).present?
        fr = Frame.find(self.image_id)
        return fr.file_url(:light)
      end
    elsif self.image_type == "Photo"
      if Photo.find_by_id(self.image_id).present?
        ph = Photo.find(self.image_id)
        return ph.file_url(:medium)
      end
    end
  end

  scope :published, -> { where(published: true) }
end
