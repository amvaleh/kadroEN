select c.name, c.latitude , c.longitude , count(c.name) as count
from photographers ph
left join locations l on l.id = ph.location_id
left join cities c on c.id = l.city_id
where ph.approved = true and length(c.name) > 0
GROUP BY c.name, c.latitude , c.longitude
ORDER BY count desc
