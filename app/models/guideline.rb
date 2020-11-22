class Guideline < ApplicationRecord
  has_many :packages, through: :guideline_packages
  has_many :guideline_packages
end
