class PhotographyTool < ApplicationRecord
  has_many :kit_photography_tools
  has_many :kits , through: :kit_photography_tools
end
