module ShareControls
  class SetPermissionSentToPhotographer
    include Interactor
    QUERY = <<-SQL
    select sh.*
    from share_controls sh
    left join frames f on f.share_control_id = sh.id
    left join galleries g on g.id = f.gallery_id
    where sh.request_sent_to_user = true and sh.permit = true and sh.permission_sent_to_photographer = false and g.id = ?
    SQL
    def call
      share_controls = ShareControl.find_by_sql([QUERY, context.gallery_id])
      share_controls.each do |share_control|
        share_control.permission_sent_to_photographer = true
        share_control.save
      end
    end
  end
end
