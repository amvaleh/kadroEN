class Lenz < ApplicationRecord
  has_many :equip_lenzs
  has_many :equipments , through: :equip_lenzs

  def display_name
    brand + " " + model
  end
end
