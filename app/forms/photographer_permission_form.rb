class PhotographerPermissionForm < Reform::Form
  property :id
  property :name_of_model
  property :name_of_action
  property :photographer_id
  property :access

  validates :name_of_model, presence: true
  validates :name_of_action, presence: true
  validates :photographer_id, presence: true
  validates :access, presence: true
  validate :unique_permission?

  private

  def unique_permission?
    return unless PhotographerPermission.
        where('name_of_model = ? and name_of_action = ? and photographer_id = ? and id <> ?',
              name_of_model, name_of_action, photographer_id, id).count > 0
    errors.add(:name_of_model, I18n.t(:''))
  end
end