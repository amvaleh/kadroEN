module Messages
  class KavenegarSendTemplate
    include Interactor
    require "httparty"

    def call
      if Rails.env.production?
        url = "https://api.kavenegar.com/v1/68642F68515548484E3753555144574C52376A5A3578576D746944426562386F51463438683956515931413D/verify/lookup.json?receptor=#{context.mobile_number}&token=#{context.token.present? ? context.token : ""}#{context.token2.present? ? "&token2=" + context.token2 : ""}#{context.token3.present? ? "&token3=" + context.token3 : ""}#{context.type.present? ? "&type=" + context.type : ""}&template=#{context.template}"
        begin
          url = URI.parse(url)
        rescue URI::InvalidURIError
          url = URI.parse(URI.escape(url))
        end
        response = HTTParty.get(url)
        result = JSON.parse(response.body)
        if result["return"]["status"] == 200
          context.result = result
        end
      end
    end
  end
end
