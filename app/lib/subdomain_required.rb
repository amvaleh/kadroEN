class SubdomainRequired
  def self.matches?(request)
    request.subdomain.present? && request.subdomain != 'www'&& request.subdomain != 'pro' && request.subdomain != 'reserve' && request.subdomain != 'app' && request.subdomain != 'locations'
  end
end
