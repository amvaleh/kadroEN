class Frame < ApplicationRecord
  mount_uploader :file, FrameUploader
  before_create :get_section_number
  has_secure_token :slug

  # has_secure_token :light_version_slug
  # before_create :add_extension
  validate :update_frame_attributes

  belongs_to :gallery
  belongs_to :share_control

  before_destroy :delete_from_cloudinary

  before_destroy :delete_associations
  attr_accessor :limit

  def get_section_number
    self.section_number = Time.now.year
  end

  def delete_associations
    self.exif.destroy if self.exif.present?
    self.share_control.destroy if self.share_control.present?
  end

  has_many :selectable_images, as: :image
  has_many :images, through: :selectable_images
  # before_save :update_frame_attributes
  belongs_to :exif

  def add_extension
    self.light_version_slug = self.light_version_slug + File.extname(self.original_filename)
  end

  def delete_from_cloudinary
    Cloudinary::Uploader.destroy(self.public_id) if self.public_id.present?
  end

  scope :downloaded, -> {
          where(:downloaded => true)
        }
  scope :liked, -> {
          where(:like => true)
        }
  scope :retouched, -> {
          where(:retouched => true)
        }

  def requested_for_share
    self.share_control.present?
  end

  # scope :share_requested, -> { where.not(:share_control_id => nil) }
  scope :share_rejected, -> { joins(:share_control).where("share_controls.permit = false") }
  scope :share_granted, -> { joins(:share_control).where("share_controls.permit = true") }
  scope :share_requested, -> { joins(:share_control) }

  def update_frame_attributes
    if self.file_changed? && self.limit.present?
      self.size = self.file.size
      max_size = self.limit
      if self.size.to_i > max_size
        self.errors.add :size, "حجم فایل بیش از حد مجاز است"
      end
    end
  end

  def correct_address
    self.downloaded ? self.file_address(false, "light") : self.file_address(false, "light")
  end

  def file_address(watermark, quality)
    if self.public_id.present? # cloudinary storage
      if watermark
        Cloudinary::Utils.cloudinary_url(self.public_id, :transformation => [
                                                           { :flags => "lossy", :quality => "auto:eco", :width => 800, :crop => "fill" },
                                                           { :effect => "brightness:70", :gravity => :center, :overlay => "kadro_logo_origin_printable_white_pibhro", :x => 0, :width => 600, :opacity => 70, :crop => "fill" },
                                                         ])
      else
        case quality
        when "original"
          Cloudinary::Utils.cloudinary_url(self.public_id)
        when "light"
          Cloudinary::Utils.cloudinary_url(self.public_id, :transformation => [
                                                             { :flags => "lossy", :quality => "auto:eco", :width => 800, :crop => "fill" },
                                                           ])
        else
          Cloudinary::Utils.cloudinary_url(self.public_id, :transformation => [
                                                             { :flags => "lossy", :quality => "auto:eco", :width => 800, :crop => "fill" },
                                                           ])
        end
      end
    else # NO public_id present, the image is localy stored:
      if watermark
        self.file_url(:watermarked)
      else
        case quality
        when "original"
          self.file_url()
        when "light"
          self.file_url(:light)
        else
          self.file_url(:light)
        end
      end
    end
  end
end
