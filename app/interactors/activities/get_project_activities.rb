module Activities
  class GetProjectActivities
    include Interactor
    QUERY = <<-SQL
      select * from activities
               where (trackable_type = 'Project' and trackable_id = ?)
                  or (trackable_type = 'Receipt' and trackable_id = ?)
                  or (trackable_type = 'Gallery' and trackable_id = ?)
                  or (trackable_type = 'Photographer' and owner_type = 'Gallery' and owner_id = ?)
                  or (recipient_type = 'Project' and recipient_id = ?)
                  or (recipient_type = 'Gallery' and recipient_id = ?)
      union
      select activities.* from activities left join photographer_payments pp on pp.id = trackable_id
      where (trackable_type = 'PhotographerPayment' and pp.project_id = ?)
      union
      select activities.* from activities left join photographer_payments pp on pp.id = recipient_id
      where (recipient_type = 'PhotographerPayment' and pp.project_id = ?) order by created_at desc;
    SQL

    def call
      project = context.project
      receipt_id = project.receipt_id.present? ? project.receipt_id : "-1"
      gallery_id = project.gallery.present? ? project.gallery.id : "-1"
      context.activities = PublicActivity::Activity.find_by_sql([QUERY, project.id, receipt_id, gallery_id, gallery_id, project.id, gallery_id, project.id, project.id])
    end
  end
end