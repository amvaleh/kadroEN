class UserForm < Reform::Form
  property :first_name
  property :last_name
  property :email
  property :full_name

#  validates :first_name, presence: true
  validates :full_name, presence: true
end
