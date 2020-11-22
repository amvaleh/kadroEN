module ShareControls
  class GetGalleriesForPermissionSentToPhotographer
    include Interactor
    QUERY = <<-SQL
select g.* , u.full_name as user_name , CONCAT(ph.first_name, ' ' , ph.last_name) as ph_name , u.mobile_number as user_mobile_number , ph.mobile_number as ph_mobile_number
from (select g.id , COUNT(g.id) as count, g.slug, g.project_id
from share_controls sh
left join frames f on f.share_control_id = sh.id
left join galleries g on g.id = f.gallery_id
where sh.request_sent_to_user = true and sh.permission_sent_to_photographer = false and sh.permit = true and g.id IS NOT NULL
GROUP BY g.id) g
left join projects p on p.id = g.project_id
left join photographers ph on ph.id = p.photographer_id
left join users u on u.id = p.user_id
    SQL
    def call
      context.data = Gallery.find_by_sql([QUERY])
    end
  end
end
