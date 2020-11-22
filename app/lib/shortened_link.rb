class ShortenedLink
  def self.matches?(request)
    request.subdomain.present? && request.subdomain != 'www' && request.subdomain == 'l'
  end
end
