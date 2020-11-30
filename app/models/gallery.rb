class Gallery < ApplicationRecord
  include PublicActivity::Model

  attr_accessor :admin_user

  belongs_to :project
  belongs_to :shortened_url, :class_name => "Shortener::ShortenedUrl"

  has_many :frames, dependent: :destroy

  after_create :set_download_limit
  after_create :set_shortened_url

  extend FriendlyId
  friendly_id :generate_token, use: :slugged

  after_update :log_activity

  def display_name
    if self.name.present?
      self.name
    else
      self.id
    end
  end

  def set_shortened_url
    self.shortened_url =
      Shortener::ShortenedUrl.generate("/galleries/#{self.slug}?utm_source=project_#{self.project.slug}&utm_medium=sharing_gallery_#{self.slug}&utm_campaign=Internal&utm_term=shoot_type_#{self.project.shoot_type.id}")
  end

  def short_url
    unless self.shortened_url.present?
      set_shortened_url
    end
    "http://l.kadro.me/#{self.shortened_url.unique_key}"
  end

  def log_activity
    if self.admin_user.present?
      self.create_activity key: "admin_update", owner: AdminUser.find(self.admin_user), recipient_type: self.changes.except(:updated_at)
    end
    # update total frames count:
    if self.frames.any?
      self.update_column(:total_frames, self.frames.count)
    end
  end

  def generate_token
    loop do
      random_token = SecureRandom.urlsafe_base64(5, false)
      break random_token unless Gallery.exists?(slug: random_token)
    end
  end

  def set_download_limit
    gallery = self
    if not self.project.package.is_full
      gallery.download_limit = self.project.package.digitals
      # add extra frames that user has, when extending the project if payed
      if gallery.project.extra_download > 0
        if gallery.project.receipt.extra_paid
          gallery.download_limit = gallery.download_limit + gallery.project.extra_download
        end
      end
      #
      gallery.save
    end
  end

  scope :have_zip, -> {
          where("galleries.zip_created_at IS NOT NULL")
        }
end
