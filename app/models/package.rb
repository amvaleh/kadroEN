class Package < ApplicationRecord
  has_many :projects
  belongs_to :shoot_type
  has_many :guidelines, through: :guideline_packages
  has_many :guideline_packages

  scope :all_frames, -> { where(is_full: true) }
  scope :active, -> { where(is_active: true) }
  scope :economy, -> { where(is_full: false) }
  scope :active, -> { where(is_active: true) }
  scope :has_shoot_type, -> {joins(:shoot_type).where('shoot_types.id is not null')}



  def photos_count
    case self.is_full
    when true
      "همه فریم ها"
    when false
      self.digitals.to_s + " انتخابی"
    end
  end

  def display_name
    if self.is_full
      out =  " #{self.duration} -" + "#{self.title}-#{self.name}- " + "همه عکسها"
    else
      out =  " #{self.duration} -" + "#{self.title}-#{self.name}- " + "#{self.digitals} عکسی"
    end
    return out
  end


  def hour_index(shoot_type , data_slider_max)
    case self.order
    when 7
      return data_slider_max
    when 0.5
      return 0
    else
      if shoot_type.packages.active.where(:order=>0.5).any?
        return self.order
        puts "nadarim"
      else
        return self.order - 1
        puts "darim"
      end
    end
  end

  def package_title
    if self.vip
      if self.name.present?
        return self.name
      else
        return "vip"
      end
    end
    if self.is_full
      return "استاندارد"
    else
      "اقتصادی"
    end
  end

end
