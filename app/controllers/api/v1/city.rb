class City < ApplicationRecord
  has_many :locations
  validates_uniqueness_of :name , :message => "این شهر قبلا ذخیره شده است."
end
