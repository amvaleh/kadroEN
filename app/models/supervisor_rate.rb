class SupervisorRate < ApplicationRecord


  validates_numericality_of :rate , :less_than => 11 , :greater_than => -1

  belongs_to :admin_user
  belongs_to :feed_back


end
