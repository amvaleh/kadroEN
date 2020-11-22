class Camera < ApplicationRecord
  has_many :equip_cameras
  has_many :equipments , through: :equip_cameras

  def display_name
    brand + " " + model
  end
end
