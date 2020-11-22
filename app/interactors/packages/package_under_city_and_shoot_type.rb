module Packages
  class PackageUnderCityAndShootType
    include Interactor

    QUERY = <<-SQL
WITH	
	discount as ( values (?))
select p.id, p.title, p.duration , concat(((table discount) * p.price::real) / 100) as price, p.digitals, p.shoot_type_id, p.order, p.extra_price,p.is_full, p.is_active, p.description, p.feature_1, p.feature_2, p.feature_3, p.feature_4, p.feature_5, p.feature_6, p.feature_7, p.vip, p.vip_url, p.name, p.real_price            
from packages p
inner join shoot_types sh on sh.id = p.shoot_type_id
where sh.id = ? AND p.is_active = true
    SQL

    def call
      context.packages = Package.find_by_sql([QUERY, context.discount, context.shoot_type_id])
    end
  end
end
