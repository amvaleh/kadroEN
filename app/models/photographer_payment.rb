class PhotographerPayment < ApplicationRecord
  include PublicActivity::Model

  attr_accessor :admin_user

  has_secure_token :uid

  belongs_to :photographer
  belongs_to :project
  belongs_to :invoice
  belongs_to :bank_gateway

  after_commit :set_ph_payment, on: [:create, :update]
  after_commit :update_ph_payment, on: [:destroy]
  after_update :log_activity

  def log_activity
    if self.admin_user.present?
      self.create_activity key: "admin_update", owner: AdminUser.find(self.admin_user), recipient_type: self.changes.except(:updated_at)
    end
  end

  scope :checked_out_but_not_ended, -> {
          PhotographerPayment.joins(:project).where("status = ? and projects.checked_out = ?", 2, true)
        }

  def set_ph_payment
    photographer_payment = self
    project = photographer_payment.project
    receipt = project.receipt
    price = 0
    PhotographerPayment.where(project_id: project.id).each do |pay|
      if pay.payment_type != 10 # payments which are not penalties.
        price = price + pay.price.to_i
      end
    end
    receipt.ph_payment = price
    receipt.save
  end

  def update_ph_payment
    photographer_payment = self
    project = photographer_payment.project
    receipt = project.receipt
    price = 0
    PhotographerPayment.where(project_id: project.id).each do |pay|
      unless pay == self
        price = price + pay.price.to_i
      end
    end
    receipt.ph_payment = price
    receipt.save
  end

  def status_title
    Lookup.where(category: "payment_status", code: status).pluck(:title)[0]
  end

  def payment_type_title
    Lookup.where(category: "payment_type", code: payment_type).pluck(:title)[0]
  end

  def photographer_full_name
    Photographer.where(id: photographer_id).
      select("concat(first_name, ' ', last_name) full_name").take(1)[0].full_name
  end
end
