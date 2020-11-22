class User < ApplicationRecord
  include PublicActivity::Common
  extend FriendlyId

  attr_accessor :admin_user

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :registerable, :recoverable, :rememberable, :trackable, :validatable, :database_authenticatable, :authentication_keys => [:mobile_number]
  devise :timeoutable

  has_many :receipts
  has_many :calls
  has_many :projects
  has_many :coupon_redemptions
  has_many :sent_user_emails
  belongs_to :business
  belongs_to :lead_source
  has_many :carts
  has_many :shoot_suggestions
  has_many :factor_items, as: :relation
  has_many :visits, class_name: "Ahoy::Visit"
  has_many :coupons

  has_one :credit, as: :owner
  has_one :refer, as: :owner

  has_one :first_visit, ->(u) { order(:started_at).where("started_at <= ?", u.created_at.to_pdate.to_date) }, class_name: "Ahoy::Visit"

  validates :mobile_number, :presence => true
  validates_length_of :mobile_number, :maximum => 11, :minimum => 11, :message => "بیشتر از ۱۱ رقم می باشد"
  validates_uniqueness_of :mobile_number, :message => "این شماره همراه قبلا ذخیره شده است"
  after_update :check_lead_source, if: :lead_source_id_changed?

  after_create :create_user_credit

  after_update :log_activity
  after_update :set_project_lead_source_from_user

  def log_activity
    if self.admin_user.present?
      self.create_activity key: "admin_update", owner: AdminUser.find(self.admin_user), recipient_type: self.changes.except(:updated_at)
    end
  end

  def set_project_lead_source_from_user
    if self.lead_source_id_changed? and self.lead_source.present?
      time = (self[:created_at] + 3.weeks).to_date.strftime("%Y-%m-%d")
      projects = Project.where("projects.created_at < '#{time}' and projects.user_id = #{self.id}")
      projects.each do |p|
        unless p.lead_source.present?
          Project.where(id: p.id).update_all(lead_source_id: self.lead_source_id)
        end
      end
    end
  end

  scope :no_leads, -> { where(:lead_source_id => nil) }
  scope :purchased, -> { joins(:projects).where("projects.is_payed = true") }

  friendly_id :generate_token, use: :slugged

  def generate_token
    Kadro::GenerateSlug.call(model: User).random_token
  end

  def display_name
    unless full_name.present?
      if first_name.present?
        if last_name.present?
          first_name + " " + last_name
        end
      else
        mobile_number.last(4).to_s
      end
    else
      if full_name != "null"
        full_name
      else
        "کاربر"
      end
    end
  end

  def display_dashboard_name
    unless full_name.present?
      if first_name.present?
        if last_name.present?
          first_name + " " + last_name
        end
      else
        "کاربر کادرو"
      end
    else
      if full_name != "null"
        full_name
      else
        "کاربر کادرو"
      end
    end
  end

  def display_name_for_message
    unless full_name.present?
      if first_name.present?
        if last_name.present?
          first_name + " " + last_name
        end
      else
        "کادرویی"
      end
    else
      if full_name != "null"
        full_name
      else
        "کاربر"
      end
    end
  end

  def create_user_credit
    Credit.create(value: 0, owner: self)
  end

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def timeout_in
    return 30.days
  end

  def check_lead_source
    if self.lead_source_id_changed?
      lead_source = self.lead_source
      lead_source.refers = lead_source.refers + 1
      lead_source.save
    end
  end

  def destroy
    raise "Cannot delete user with projects" unless self.projects.count == 0
    # ... ok, go ahead and destroy
    super
  end

  def refer_key
    unless self.refer.present?
      refer = Refers::ReferCreate.call(data: { owner: self })
      refer.refer.model.key
    else
      self.refer.key
    end
  end
end
