class PhotographyLocations
  def self.matches?(request)
    request.subdomain.present? && request.subdomain != 'www' && request.subdomain == 'locations'
  end
end
