class FeedBack < ApplicationRecord

  validates :project_id, presence: true
  validates_numericality_of :qrate , :less_than => 11 , :greater_than => -1
  validates_numericality_of :arate , :less_than => 11 , :greater_than => -1

  belongs_to :project
  has_many :supervisor_rates

  def display_name
    return ( self.id.to_s + "-" + self.project.user.display_name.to_s + "-" + self.project.user.mobile_number.to_s)
  end

  def had_mask
    self.used_mask ? "با ماسک" : "بدون ماسک"
  end

end
