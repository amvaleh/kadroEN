class Kit < ApplicationRecord
  has_many :equipment_kits
  has_many :equipments , through: :equipment_kits

  has_many :kit_photography_tools
  has_many :photography_tools , through: :kit_photography_tools
end
