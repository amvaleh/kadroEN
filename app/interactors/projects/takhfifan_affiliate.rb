require "uri"
require "net/http"
module Projects
  class TakhfifanAffiliate
    include Interactor
    def call
      project = context.project
      # byebug
      user = project.user
      if user.visits.any? and user.visits.first.utm_source=="takhfifan" and user.visits.first.utm_term.present?
      uri = URI('https://analytics.takhfifan.com/track/purchase')
      req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
      req.body = {'token' => "#{user.visits.first.utm_term.to_s}",
      'transaction_id' => "##{project.id}",
      'revenue'=> "#{project.receipt.subtotal}",
      'shipping'=> "#{project.receipt.transportion_cost}",
      'tax' => 0,
      'discount' => "#{(project.receipt.total.to_i - project.receipt.subtotal.to_i)}",
      'new_customer' => "true",
      'affiliation' => 'takhfifan',
      'coupon_code' => "#{project.coupon.title if project.coupon.present?}" ,
      'items' =>[
        {
          'product_id'=> "#{project.package.id.to_s}",
          'sku'=>"#{project.slug}",
          'category'=>"#{project.shoot_type.title}",
          'price'=>"#{project.package.price}",
          'quantity'=> "1",
          'name'=>"#{project.package.title}"
        }
      ]
    }.to_json
    x = 0;
    # byebug
    res = Net::HTTP.start(uri.hostname, uri.port,:use_ssl => uri.scheme == 'https') do |http|
      x = http.request(req)
    end
    puts x.body
  end
end
end
end
