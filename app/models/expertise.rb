class Expertise < ApplicationRecord
  belongs_to :photographer
  belongs_to :shoot_type
  has_many :photos, dependent: :delete_all
  has_many :expertise_widgets, dependent: :delete_all

  mount_uploaders :samples, AvatarUploader
  serialize :samples, JSON

  after_update :photographer_update, :add_shoot_type_location
  after_create :approve_me
  before_destroy :remove_shoot_type_location

  def photographer_update
    photographer.update(:updated_at => Time.now)
  end

  def approve_me
    exp = self
    exp.approved = true
    exp.save
  end

  def shoot_type_active
    where("shoot_type.active = ?", true)
  end

  def self.ransackable_scopes(_auth_object = nil)
    [:approved_photographer]
  end

  def remove_shoot_type_location
    studio = ShootLocation.find_by(is_studio: true, photographer_id: self.photographer.id)
    if studio.present?
      shoot_type_location = ShootTypeLocation.find_by(shoot_location_id: studio.id, shoot_type_id: self.shoot_type.id)
      if shoot_type_location.present?
        shoot_type_location.destroy
      end
    end
  end

  def add_shoot_type_location
    if self.approved_changed?
      if self.approved?
        studio = ShootLocation.find_by(is_studio: true, photographer_id: self.photographer.id)
        if studio.present?
          shoot_type_location = ShootTypeLocation.find_by(shoot_location_id: studio.id, shoot_type_id: self.shoot_type.id)
          if !shoot_type_location.present?
            shoot_type_location = ShootTypeLocation.new(shoot_location_id: studio.id, shoot_type_id: self.shoot_type.id)
            shoot_type_location.save
          end
        end
      elsif !self.approved?
        studio = ShootLocation.find_by(is_studio: true, photographer_id: self.photographer.id)
        if studio.present?
          shoot_type_location = ShootTypeLocation.find_by(shoot_location_id: studio.id, shoot_type_id: self.shoot_type.id)
          if shoot_type_location.present?
            shoot_type_location.destroy
          end
        end
      end
    end
  end

  scope :approved, -> { where(approved: true) }
  scope :valid, -> { where("photographer_id <> null ") }
  scope :approved_photographer, -> { joins(:photographer).where("photographers.approved is true") }
end
