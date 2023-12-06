class Photographer < ApplicationRecord
  include PublicActivity::Common
  visitable :ahoy_visit

  attr_accessor :admin_user

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :registerable,
         :recoverable, :rememberable, :confirmable, :trackable, :validatable, :database_authenticatable


  require "carrierwave/orm/activerecord"
  validates_uniqueness_of :email
  # validates_presence_of :first_name, :last_name

  has_many :calls
  has_many :photographer_attachments
  has_many :projects
  has_many :photographer_payments
  has_many :shop_order_details
  has_many :shoot_types, through: :expertises
  belongs_to :location
  belongs_to :join_step
  belongs_to :grade
  belongs_to :business
  has_one :equipment, dependent: :destroy
  has_one :experience, dependent: :destroy
  has_one :scanned_profile, dependent: :destroy
  has_many :expertises, dependent: :delete_all
  has_many :free_times, dependent: :delete_all
  has_one :bank_account, dependent: :delete
  has_many :sent_photographer_emails
  has_many :free_times_histories, dependent: :delete_all
  belongs_to :parent, :class_name => "Photographer", :foreign_key => "parent_photographer_id", optional: true
  has_many :child_photographers, :class_name => "Photographer", :foreign_key => "parent_photographer_id"
  has_many :shoot_suggestions
  has_many :photographer_permissions
  has_many :project_candidates
  has_many :shoot_locations
  belongs_to :call_status

  has_one :credit, as: :owner
  has_one :refer, as: :owner

  has_one :first_visit, ->(u) { order(:started_at).where("started_at < ?", u.created_at.to_pdate.to_date) }, class_name: "Ahoy::Visit"
  has_one :active_studio, ->(u) { where(is_studio: true, approved: true) }, class_name: "ShootLocation"

  def send_on_create_confirmation_instructions
    # send_devise_notification(:confirmation_instructions)
  end

  after_update :check_join_step
  after_update :log_activity
  before_save :check_state
  before_save :set_last_step_time

  def registering
    if self.join_step.name == "اطلاعات اولیه" or self.join_step.name == "تجهیزات عکاسی" or self.join_step.name == "اطلاعات مکانی" or self.join_step.name == "نمونه کارها" or self.join_step.name == "تجربه کاری" or self.join_step.name == "پروفایل ناقص"
      return true
    else
      return false
    end
  end
 

  def total_done_projects_in_lifetime
    if self.experience.present?
      self.experience.projects_payed_count.present? ? (self.experience.projects_payed_count + self.projects.confirmed.count) : (self.projects.confirmed.count)
    else
      0
    end
  end

  def total_years_have_worked
    self.experience.years_been_photographer.present? ? (self.experience.years_been_photographer + (Time.now.to_date.to_pdate.year - self.created_at.to_pdate.year)) : (Time.now.to_date.to_pdate.year - self.created_at.to_pdate.year)
  end

  #
  # def contracting
  #   if self.join_step.name=="تاییدیه" or self.join_step.name=="پروفایل ناقص" or self.join_step.name=="تایید اما ناقص" or self.join_step.name=="تایید مسئول" or self.join_step.name == "در انتظار مصاحبه" or self.join_step.name == "تاریخ مصاحبه" or self.join_step.name == "حق"
  #     return true
  #   end
  # end

  def has_passed(join_name)
    self.join_step_id >= JoinStep.find_by(name: join_name).id
  end

  def set_last_step_time
    if self.join_step_id_changed?
      self.last_step_at = Time.now
    end
  end



  def check_join_step
    if self.join_step_id_changed? and self.join_step_id.present?
      if self.join_step.name == "تایید اما ناقص"
        # Photographers::SmsIncompleteProfile.call(photographer_id: self.id)
        EmailIncompleteProfile.perform_async(self.id)
      elsif self.join_step.name == "پروفایل ناقص"
        # EmailIncompleteProfile.perform_async(self.id)
        Photographers::SmsIncompleteProfile.call(photographer_id: self.id)
      elsif self.join_step.name == "لغو عضویت" && self.rejected
        Photographers::MessageForRejectAndCancelMembership.call(photographer_id: self.id)
      elsif self.join_step.name == "عدم تمایل به همکاری"
        Photographers::MessageForLackOfCooperation.call(photographer_id: self.id)
      elsif self.join_step.name == "در انتظار مصاحبه"
        Photographers::SmsWaitForInterview.call(photographer: self)
      elsif self.join_step.name == "تاریخ مصاحبه"
        if self.interview_date.present?
          EmailInterviewPhotographer.perform_async(self.id)
          Photographers::SmsInviteToInterview.call(photographer_id: self.id)
        end
      end
    end
  end

  def log_activity
    if self.admin_user.present?
      self.create_activity key: "admin_update", owner: AdminUser.find(self.admin_user), recipient_type: self.changes.except(:updated_at)
    end
  end

  mount_uploader :avatar, AvatarUploader

  extend FriendlyId
  friendly_id :email, use: :slugged

  def check_uid_is_nil
    uid != nil && uid != ""
  end


  def check_state
    if self.rejected_changed?
      if self.rejected
        # EmailRejectPhotographer.perform_async(self.id)
      end
    end
    if self.approved_changed?
      if self.approved and self.approved_at == nil
        self.approved_at = Time.now
      end
    end
  end

  def abbrv_name
    if first_name or last_name
      first_name.chars.first + ".  " + last_name
    else
      email
    end
  end

  def display_name
    if first_name or last_name
      first_name + " " + last_name
    else
      email
    end
  end

  def pointer
    if self.approved
      "  * "
    else
      " "
    end
  end

  # def page_url
  #   if Rails.env.development?
  #     "http://" + self.uid.to_s + ".localhost:3000"
  #   else
  #     "http://#{self.uid.to_s}.kadro.me"
  #   end
  # end

  # def pro_url
  #   if Rails.env.development?
  #     # self.uid.to_s
  #     "http://pro.localhost:3000/" + self.uid.to_s
  #   else
  #     "https://pro.kadro.me/" + self.uid.to_s
  #   end
  # end

  def email_required?
    false
  end

  def email_changed?
    false
  end

  scope :completing, -> {
          where(:rejected => false, :approved => false)
        }
  scope :rejected, -> {
          where(:rejected => true)
        }
  scope :active, -> { where(approved: true) }
  scope :wating, -> { where(approved: false, rejected: false) }

  scope :approved, -> {
          where(:approved => true)
        }

  scope :checked, -> { where(checked: true) }
  scope :not_checked, -> { where("coalesce(checked, false) = false") }
  scope :male, -> {
          where(:gender => 2)
        }
  scope :female, -> {
          where(:gender => 1)
        }
  scope :with_studio, -> {
          where(:has_studio => true)
        }

  def has_free_time?(date_time, offset_time, day_of_week)
    # offset_time is integer exp:3600 => 1 hours
    if (self.free_times.where(day: day_of_week).where("free_times.start <= ?", date_time.strftime("%H:%M")).where("free_times.end >= ?", (date_time + offset_time.hours).strftime("%H:%M"))).any?
      @projects = self.projects.where("date(start_time) = (?)", date_time)
      @projects.each do |project| #Check reservations
        project_start = project.start_time.to_time
        request_start = date_time.to_time
        if times_overlap?((request_start - 59.minutes).strftime("%H:%M"), (request_start + order_to_duration(offset_time) + 59.minutes).strftime("%H:%M"), project_start.strftime("%H:%M"), (project_start + order_to_duration(project.package.order)).strftime("%H:%M"))
          return false
        end
      end
      return true
    end
    return false
  end

  def times_overlap?(start_time, end_time, start_bound, end_bound)
    start_time.between?(start_bound, end_bound) || end_time.between?(start_bound, end_bound) || start_bound.between?(start_time, end_time) || end_bound.between?(start_time, end_time)
  end

  def order_to_duration(order_recieved)
    case order_recieved
    when 1
      30.minutes
    when 2
      1.hour
    when 3
      2.hours
    when 4
      3.hours
    when 5
      4.hours
    when 6
      7.hours
    end
  end

  def total_free_times
    FreeTimes::CalculateAvailableWeekHours.call(photographer_id: self.id).available_hours
  end

  def if_has_studio
    if self.active_studio.present?
      return true
    else
      return false
    end
  end
end
