module ActiveAdminComments
  class GetProjectComments
    include Interactor

    QUERY = <<-SQl
    select * from active_admin_comments where (resource_type = 'Project' and resource_id = ?)
                                        or (resource_type = 'Gallery' and resource_id = ?)
                                        or (resource_type = 'Receipt' and resource_id = ?)
                                        or (resource_type = 'User' and resource_id = ?)
    union
    select active_admin_comments.* from active_admin_comments left join photographer_payments pp on pp.id = resource_id
    where (resource_type = 'PhotographerPayment' and pp.project_id = ?) order by created_at desc;
    SQl

    def call
      project = context.project
      receipt_id = project.receipt_id.present? ? project.receipt_id : "-1"
      gallery_id = project.gallery.present? ? project.gallery.id : "-1"
      context.comments = ActiveAdminComment.find_by_sql([QUERY, project.id, gallery_id, receipt_id, project.user_id, project.id])
    end
  end
end