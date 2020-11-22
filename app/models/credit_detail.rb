class CreditDetail < ApplicationRecord
  include PublicActivity::Model
  attr_accessor :current_admin_user
  belongs_to :credit
  belongs_to :credit_detail_type
  belongs_to :project
  validate :project_for_user
  after_create :add_value_to_credit
  before_destroy :remove_value_from_credit
  before_update :change_value_from_credit
  after_update :log_activity_update
  after_create :log_activity_create

  def log_activity_update
    if self.current_admin_user.present?
      self.create_activity key: "admin_update", owner: AdminUser.find(self.current_admin_user), recipient_type: self.changes.except(:updated_at)
    end
  end

  def log_activity_create
    if self.current_admin_user.present?
      self.create_activity key: "admin_create", owner: AdminUser.find(self.current_admin_user), recipient_type: self.changes.except(:updated_at)
    end
  end

  def change_value_from_credit
    if self.value.present? and self.value_changed?
      credit = Credit.find_by(id: self.credit_id)
      last_detail = CreditDetail.find_by(id: self.id)
      if credit.present?
        credit.value = credit.value - last_detail.value
        credit.value = credit.value + self.value
        credit.save
      end
    end
  end

  def remove_value_from_credit
    if self.value.present?
      credit = Credit.find_by(id: self.credit_id)
      if credit.present?
        credit.value = credit.value - self.value
        credit.save
      end
    end
  end

  def add_value_to_credit
    if self.value.present?
      credit = Credit.find_by(id: self.credit_id)
      if credit.present?
        credit.value = credit.value + self.value
        credit.save
      end
    end
  end

  def project_for_user
    if self.credit.present?
      user = User.find_by(id: self.credit.owner_id)
      if user.present?
        if self.project_id.present?
          if self.project.user != user
            errors.add(:credit_detail, "project not valid !")
          end
        end
      else
        errors.add(:credit_detail, "user not valid !")
      end
    else
      errors.add(:credit_detail, "credit not valid !")
    end
  end
end
