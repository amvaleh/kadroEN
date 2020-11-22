class Ahoy::Store < Ahoy::DatabaseStore
end

# set to true for JavaScript tracking
Ahoy.api = true
Ahoy.visit_duration = 12.hours
Ahoy.exclude_method = lambda do |controller, request|
  request.original_url.include?("admin")
end
Ahoy.cookie_domain = :all
