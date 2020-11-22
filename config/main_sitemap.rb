# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://www.kadro.co"
SitemapGenerator::Sitemap.sitemaps_path = "sitemaps/main"
# SitemapGenerator::Sitemap.create_index = true
SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  add '/contact_us' , :changefreq => 'monthly'
  add '/about_us', :changefreq => 'monthly'
  add '/join_us' , :changefreq => 'monthly'
  add '/pricing' , :changefreq => 'monthly'
  add '/print_prices' , :changefreq => 'monthly'
  add '/terms' , :changefreq => 'monthly'
  add '/privacy' , :changefreq => 'monthly'
  add '/faq' , :changefreq => 'monthly'
  add '/enterprises' , :changefreq => 'monthly'
  add '/standard_edit' , :changefreq => 'monthly'
  add '/retouch_edit' , :changefreq => 'monthly'
  add '/submit-project' , :changefreq => 'monthly'
  ShootType.all.active.find_each do |sh|
    add types_show_path(title: sh.w_url) , :lastmod => sh.updated_at.to_pdate.to_date, :changefreq => 'weekly'
  end
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
end
