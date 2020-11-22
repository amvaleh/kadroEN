# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://pro.kadro.co"
SitemapGenerator::Sitemap.sitemaps_path = "sitemaps/pro"
SitemapGenerator::Sitemap.create do
  # add '/contact_us'
  #
  #
  shoot_typess = Expertise.joins(:photographer).where(:photographers => { approved: true }, :expertises => { approved: true }).group(:shoot_type_id).count

  shoot_typess.each do |shid|
    shoot_type = ShootType.find(shid.first)
    add expertise_only_path(shoot_type.title) , :lastmod => shoot_type.updated_at.to_pdate.to_date, :changefreq => 'yearly'
  end

  ActiveCity.all.each do |city|
    add city_path(city.name) , :changefreq => 'yearly'
  end

  Photographer.all.where(:approved=>true).each do |p|
    add prophotographer_show_path(id: p.uid.to_s) , :lastmod => p.updated_at.to_pdate.to_date, :changefreq => 'weekly'
  end
  #
end
