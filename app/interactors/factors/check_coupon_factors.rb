module Factors
  class CheckCouponFactors
    include Interactor

    def call
      invoice_items = Cart.find(context.cart_id).invoice.invoice_items
      has_used_coupon = false
      invoice_items.each do |invoice_item|
        unless invoice_item.invoice_factor.nil?
          has_used_coupon = true
          break
        end
      end
      included_invoice_items = []
      user = context.user
      coupon = Coupon.where(code: context.code).first
      unless has_used_coupon
        if coupon.present?
          result = Coupons::CheckCoupon.call(code: context.code)
          context.result = result.result
          if result.successful
            factor = coupon.factor.first
            if factor.present?

              if coupon.applied_times.nil?
                coupon.applied_times = 0
              end
              coupon.applied_times = coupon.applied_times + 1
              coupon.save

              case factor.relation_type
              when 1
                included_invoice_items = invoice_items

              when 2
                items = factor.factor_items.where(relation_type: 'Item').pluck(:relation_id)
                invoice_items.each do |invoice_item|
                  if items.include? invoice_item.cart_item.item_id
                    included_invoice_items << invoice_item
                  end
                end

              when 3
                users = factor.factor_items.where(relation_type: 'User').pluck(:relation_id)
                if users.include? user.id
                  included_invoice_items = invoice_items
                else
                  context.result = {response: 'error', message: "این کد تخفیف مربوط به حساب کاربری شما نمی باشد."}
                end

              when 4
                users = factor.factor_items.where(relation_type: 'User').pluck(:relation_id)
                if users.include? user.id
                  items = factor.factor_items.where(relation_type: 'Item').pluck(:relation_id)
                  invoice_items.each do |invoice_item|
                    if items.include? invoice_item.cart_item.item_id
                      included_invoice_items << invoice_item
                    end
                  end
                else
                  context.result = {response: 'error', message: "این کد تخفیف مربوط به حساب کاربری شما نمی باشد."}
                end
              end

              if included_invoice_items.any?
                total = 0
                invoice_items.each do |invoice_item|
                  total = total + invoice_item.price
                end
                invoice_factors = []
                case factor.relation_type
                when 2, 4
                  included_invoice_items.each do |invoice_item|
                    if factor.value_type == 1
                      coupon_price = factor.value / included_invoice_items.size
                      context.result = {response: 'ok', message: "تبریک، #{factor.value.to_i} تومان تخفیف به فاکتور شما بابت محصولات مشمول این کد تخفیف اعمال شد."}
                    elsif factor.value_type == 2
                      coupon_price = factor.value * invoice_item.price / 100
                      context.result = {response: 'ok', message: "تبریک، #{factor.value} درصد تخفیف به فاکتور شما بابت محصولات مشمول این کد تخفیف اعمال شد."}
                    end
                    invoice_factors << InvoiceFactor.create(invoice_item_id: invoice_item.id, factor_id: factor.id, value: coupon_price)
                  end
                  context.result[:item_relation] = true
                when 3
                  if factor.value_type == 1
                    coupon_price = factor.value
                    context.result = {response: 'ok', message: "تبریک، #{factor.value.to_i} تومان تخفیف به فاکتور شما اعمال شد."}
                  elsif factor.value_type == 2
                    coupon_price = factor.value * total / 100
                    context.result = {response: 'ok', message: "تبریک، #{factor.value} درصد تخفیف به فاکتور شما اعمال شد."}
                  end
                  included_invoice_items.each do |invoice_item|
                    invoice_factors << InvoiceFactor.create(invoice_item_id: invoice_item.id, factor_id: factor.id, value: coupon_price / included_invoice_items.size)
                  end
                when 1
                  if factor.value_type == 1
                    coupon_price = factor.value / total
                    context.result = {response: 'ok', message: "تبریک، #{factor.value.to_i} تومان تخفیف به فاکتور شما اعمال شد."}
                  elsif factor.value_type == 2
                    coupon_price = factor.value * total / (100 * total)
                    context.result = {response: 'ok', message: "تبریک، #{factor.value} درصد تخفیف به فاکتور شما اعمال شد."}
                  end
                  included_invoice_items.each do |invoice_item|
                    invoice_factors << InvoiceFactor.create(invoice_item_id: invoice_item.id, factor_id: factor.id, value: coupon_price * invoice_item.price)
                  end
                end
                total_discount = 0
                invoice_factors.each do |invoice_factor|
                  total_discount = total_discount + invoice_factor.value
                end
                context.result[:invoice_factors] = invoice_factors
                context.result[:total_discount] = total_discount
              else
                unless context.result.present? and context.result[:response] == 'error'
                  context.result = {response: 'error', message: "این کد تخفیف شامل آیتم های فاکتور شما نمی شود."}
                end
              end
            end
          end
        else
          context.result = {response: 'error', message: "این کد تخفیف موجود نمی باشد."}
        end
      else
        context.result = {response: 'error', message: "شما یک کد تخفیف ثبت کرده اید."}
      end
    end
  end
end