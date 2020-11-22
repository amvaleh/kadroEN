class ProPhotographers
  def self.matches?(request)
    request.subdomain.present? && request.subdomain != 'www' && request.subdomain == 'pro'
  end
end
