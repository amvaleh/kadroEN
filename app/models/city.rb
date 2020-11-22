class City < ApplicationRecord
  has_many :locations
  has_many :addresses
  validates_uniqueness_of :name , :message => "این شهر قبلا ذخیره شده است."
end
