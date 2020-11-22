class SmsWorker
  include Sidekiq::Worker

  def perform(message, phone_number)
    pass = "smspanel810190501"
    result = Net::HTTP.get(URI.parse(URI.encode("http://smspanel.Trez.ir/SendMessageWithUrl.ashx?Username=arcasimap&Password=#{pass}&PhoneNumber=30008632000014&MessageBody=#{message}&RecNumber=#{phone_number}&Smsclass=1")))
    # paramz = {}
    # reciept = phone_number
    # if reciept[0] == "0"
    #   reciept.slice(0)
    # end
    # isdn = '+98' + reciept.to_s
    # encoded = URI.encode("https://bulksms.vsms.net/eapi/submission/send_sms/2/2.0?username=amvaleh&password=bulksms810190501&message=#{message}&msisdn=#{isdn}")
    # result = Net::HTTP.post_form(URI.parse(encoded),paramz)
    puts result
    if result.to_i > 2000
      Message.create(mobile_number: phone_number, body: message)
      return true
    end
    raise "error number #{result.to_i}"
  end
end
