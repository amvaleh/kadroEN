module SelectableImages
  class SelectTopImages
    include Interactor

    QUERY = <<-SQL
    SELECT DISTINCT i.image_id , i.id , i.image_type , i.like_number , i.dislike_number , i.title , i.point
    from(select i.* , sh2.title , CAST(concat( 2*i.like_number - i.dislike_number) AS int) as point
    from selectable_images i
    right join selectable_image_shoot_types sh on sh.selectable_image_id = i.id
    left join shoot_types sh2 on sh2.id = sh.shoot_type_id
    where i.published = true AND sh2.id = ?
    ORDER BY point DESC
    LIMIT ?) i
    order by i.point DESC
    SQL

    def call
      context.limit = Setting.find_by_var("limit_for_selectable_images_search").value.to_i
      context.photos = SelectableImage.find_by_sql([QUERY, context.shoot_type, context.limit])
    end
  end
end
