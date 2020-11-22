class Equipment < ApplicationRecord
  self.table_name = "equipments"

  belongs_to :photographer

  has_many :equip_cameras , dependent: :destroy
  has_many :cameras , through: :equip_cameras , dependent: :destroy

  has_many :equip_lenzs
  has_many :lenzs , through: :equip_lenzs

  has_many :equipment_kits
  has_many :kits , through: :equipment_kits

  after_update :photographer_update

  def photographer_update
      photographer.update(:updated_at => Time.now)
  end

end
