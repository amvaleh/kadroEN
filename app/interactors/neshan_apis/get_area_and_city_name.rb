module NeshanApis
  class GetAreaAndCityName
    include Interactor
    require "httparty"

    def call
      if Rails.env.production?
        token = "service.zxfXcIUQnzlR97KubhRmAZXvwvOKdqBNXRKazF0X"
      elsif Rails.env.development?
        token = "service.e35e4pY5PLyGTTezMcGKxGKIwoEQJ1oY5ud9UcfJ"
      end
      url = "https://api.neshan.org/v2/reverse?lat=#{context.lat}&lng=#{context.long}"
      headers = {
        "Api-Key": "#{token}",
      }
      response = HTTParty.get(url, headers: headers)
      results = JSON.parse(response.body)
      if results["neighbourhood"] != nil && results["neighbourhood"] != ""
        context.neighbourhood = results["neighbourhood"]
      else
        context.neighbourhood = "غیره"
      end
      if results["city"] != nil && results["city"] != ""
        context.city = results["city"]
      elsif results["state"] != nil && results["state"] != ""
        context.city = results["state"]
      else
        context.city = "غیره"
      end
      if results["state"] != nil && results["state"] != ""
        context.state = results["state"]
      else
        context.state = "غیره"
      end
      if results["formatted_address"] != nil && results["formatted_address"] != ""
        context.address = results["formatted_address"]
      else
        context.address = "غیره"
      end
    end
  end
end
