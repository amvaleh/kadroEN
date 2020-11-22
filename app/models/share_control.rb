class ShareControl < ApplicationRecord
  has_one :frame


  def status
    self.permit ? "اجازه داده شده" : "غیر قابل استفاده"
  end

  def shoot_type_id
    self.frame.gallery.project.shoot_type_id
  end

  def self.ransackable_scopes(_auth_object = nil)
    [:shoot_type_select ,:photographer_select]
  end

  scope :approved_photographer, -> { joins(:photographer).where("photographers.approved is true") }
  scope :shoot_type_select, -> (shoot_type_id) { joins("INNER JOIN frames ON frames.share_control_id = share_controls.id INNER JOIN galleries ON galleries.id = frames.gallery_id INNER JOIN projects ON projects.id = galleries.project_id").where('projects.shoot_type_id = ?', shoot_type_id) }
  scope :photographer_select, -> (photographer_id) { joins("INNER JOIN frames ON frames.share_control_id = share_controls.id INNER JOIN galleries ON galleries.id = frames.gallery_id INNER JOIN projects ON projects.id = galleries.project_id").where('projects.photographer_id = ?', photographer_id) }


end
