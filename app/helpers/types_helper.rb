module TypesHelper

  def assets_url(address)
    if Rails.env.production?
      "https://app.kadro.co" + address.to_s
    else
      address
    end
  end

end
