class Business < ApplicationRecord
  has_many :projects
  has_many :photographers
  has_many :users
  belongs_to :admin_user
end
