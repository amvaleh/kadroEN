# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://locations.kadro.co"
SitemapGenerator::Sitemap.sitemaps_path = "sitemaps/locations"
SitemapGenerator::Sitemap.create do
  # add '/contact_us'
  ShootLocation.where(approved: true).not_studio.each do |sl|
    add shoot_location_show_path(sl.slug) , :lastmod => sl.updated_at.to_pdate.to_date, :changefreq => 'monthly'
  end

  ShootTypes::SelectShootTypesHaveShootLocation.call().shoot_types.each do |sh|
    add shoot_location_shoot_type_filter_path(sh.title) , :lastmod => sh.updated_at.to_pdate.to_date, :changefreq => 'monthly'
  end

  ShootLocationType.all.each do |slt|
    add shoot_location_type_filter_path(slt.title) , :lastmod => slt.updated_at.to_pdate.to_date, :changefreq => 'monthly'
  end

  #
end
