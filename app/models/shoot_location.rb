class ShootLocation < ApplicationRecord
  extend FriendlyId
  friendly_id :generate_token, use: :slugged

  belongs_to :photographer
  belongs_to :shoot_location_type
  belongs_to :address, dependent: :destroy
  has_many :shoot_type_locations
  has_many :shoot_location_attachments
  accepts_nested_attributes_for :shoot_location_attachments

  after_save :check_has_studio
  after_destroy :check_photographer_has_studio
  before_save :check_studio_shoot_location_type

  def check_has_studio
    if self.is_studio_changed? || self.approved_changed?
      if self.photographer.present? && self.is_studio == true && self.approved == true
        self.photographer.has_studio = true
      elsif (self.photographer.present? && self.is_studio == false) || (self.photographer.present? && self.is_studio == true && self.approved == false)
        studio_location = ShootLocation.find_by(photographer_id: self.photographer_id, is_studio: true, approved: true)
        if !studio_location.present?
          self.photographer.has_studio = false
        end
      end
      self.photographer.save
    end
  end

  def check_photographer_has_studio
    if self.photographer.present? && self.is_studio == true
      self.photographer.has_studio = true
      studio_location = ShootLocation.find_by(photographer_id: self.photographer_id, is_studio: true)
      if !studio_location.present?
        self.photographer.has_studio = false
      end
    end
    self.photographer.save
  end

  def check_studio_shoot_location_type
    if self.is_studio_changed?
      if self.photographer.present? && self.is_studio == true
        shoot_location_type = ShootLocationType.find_by(title: "آتلیه")
        self.shoot_location_type_id = shoot_location_type.id
      end
    end
  end

  def generate_token
    loop do
      random_token = SecureRandom.urlsafe_base64(5, false)
      break random_token unless ShootLocation.exists?(slug: random_token)
    end
  end


  scope :not_studio, -> {
    where(:is_studio => false)
  }

end
