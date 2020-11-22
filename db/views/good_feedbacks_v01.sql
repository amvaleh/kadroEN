select f5.*
from (select f4.* , g.total_frames
from (select f3.* , pa.order , sh.title
from (select f2.* , c.name
from (select f1.* , concat(ph.first_name,' ',ph.last_name) as ph_display_name , ph.location_id
from (select f.id as feed_back_id, f.qrate, f.arate, f.description, p.id as project_id, p.photographer_id , p.package_id , p.receipt_id , p.start_time , p.extend_hours
from feed_backs f
left join projects p on p.id = f.project_id
where f.arate > 8 and f.qrate > 8 and length(f.description) > 10 and f.publishable = true and p.checked_out = true) f1
left join photographers ph on ph.id = f1.photographer_id
where ph.approved = true) f2
left join locations l on l.id = f2.location_id
left join cities c on c.id = l.city_id
where length(c.name) > 0) f3
left join packages pa on pa.id = f3.package_id
left join shoot_types sh on sh.id = pa.shoot_type_id
where pa.order > 0) f4
left join galleries g on g.project_id = f4.project_id
where g.total_frames > 20) f5
order by qrate DESC , arate DESC
