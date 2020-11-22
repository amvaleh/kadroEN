class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def created_at
    "#{self[:created_at].to_date.to_pdate} ** #{self[:created_at].to_date.to_pdate.strftime("%A")}  **  #{self[:created_at].strftime("ساعت %I:%M%p")}" if self[:updated_at].present?
  end
  #
  def updated_at
    "#{self[:updated_at].to_date.to_pdate} ** #{self[:updated_at].to_date.to_pdate.strftime("%A")}  **  #{self[:updated_at].strftime("ساعت %I:%M%p")}" if self[:updated_at].present?
  end

  def current_sign_in_at
    "#{self[:current_sign_in_at].to_date.to_pdate} ** #{self[:current_sign_in_at].to_date.to_pdate.strftime("%A")}  **  #{self[:current_sign_in_at].strftime("ساعت %I:%M%p")}" if self[:current_sign_in_at].present?
  end

  def last_sign_in_at
    "#{self[:last_sign_in_at].to_date.to_pdate} ** #{self[:last_sign_in_at].to_date.to_pdate.strftime("%A")}  **  #{self[:last_sign_in_at].strftime("ساعت %I:%M%p")}" if self[:last_sign_in_at].present?
  end

  def updated_at_in_gregorian
    self[:updated_at]
  end
end
