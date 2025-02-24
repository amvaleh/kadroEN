class ShootType < ApplicationRecord

  has_many :packages
  has_many :projects
  has_many :coupon_shoot_types
  has_many :relevants

  has_many :expertises
  has_many :photographers , through: :expertises

  has_many :shoot_type_partners
  has_many :partners , through: :shoot_type_partners


  # mount_uploader :avatar, AvatarUploader
  mount_uploaders :samples, SampleUploader

  scope :personalz, -> { where(is_personal: true) }

  scope :businessz, -> { where(is_personal: false) }

  scope :active, -> { where(is_active: true) }

  scope :is_personal, -> { where(is_personal: true) }
  scope :is_business, -> { where(is_business: true) }


  def data_slider_ticks
    total = []
    tah = self.packages.active.group(:duration).count.count - 1
    for i in 0..tah do
      total << i
    end
    return total
  end

  def data_slider_ticks_labels
    labels = []
    # self.packages.active.group(:duration,:order).count.each do |gp|
      self.packages.active.group(:order,:duration).count.sort_by{|dur,val| dur.first}.each do |gp|
      labels << gp.first.second.to_s
    end
    return labels
  end


end
