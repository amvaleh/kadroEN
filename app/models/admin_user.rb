class AdminUser < ApplicationRecord
  include PublicActivity::Common
  has_many :projects

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  role_based_authorizable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :recoverable, :rememberable, :trackable, :validatable ,:database_authenticatable, :authentication_keys => [:email]
  has_one :business
    scope :in_about, -> {
    where(:about_display => true)
  }



  def display_name
    if self.first_name.present? and self.last_name.present?
      return "#{self.first_name} #{self.last_name}"
    else
      return self.email
    end
  end


  mount_uploader :avatar, AvatarUploader



end
