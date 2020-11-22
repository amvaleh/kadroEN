module Invoices
  class UserAddress
    include Interactor

    def call
      result = Cart.joins(invoice: :address).select('addresses.*').
          where('user_id = ?', context.user_id).order('invoices.created_at desc').take(1)[0]
      if result.nil?
        result = Gallery.joins(project: :address).select('addresses.*').
            where('user_id = ? and confirmed = ? and is_payed = ?', context.user_id, true, true).
            order('projects.start_date desc').take(1)[0]
      end
      if result.nil?
        result = Address.new
      end
      context.result = result
    end
  end
end