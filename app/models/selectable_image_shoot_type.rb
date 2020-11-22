class SelectableImageShootType < ApplicationRecord
  belongs_to :selectable_image
  belongs_to :shoot_type
end
