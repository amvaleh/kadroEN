class Api::V3::PackagesController < ApiController
  respond_to :json
  before_action :find_project

  def submit_package
    unless reserve_params[:package_id]
      render json: { errors: ["مقدار صحیح را وارد نمایید"] }.to_json, status: :bad_request
      return
    end
    @package = Package.find_by(id: reserve_params[:package_id])
    if @package.present?
      @project.package = @package
      @project.save
      impression_discount_package_for_city = @package.price.to_i - ((@package.price.to_i * @project.address.city.impression_discount_package) / 100)
      subtotal_after_discount_city = @project.package.price.to_i - impression_discount_package_for_city
      @project.create_activity :submitted_package, owner: @project.user, recipient: @package
      receipt = @project.receipt
      ph_payment = 0
      if receipt
        #receipt = @project.receipt
        receipt.total = @project.package.price
        receipt.subtotal = subtotal_after_discount_city
        receipt.ph_payment = receipt.calculate_ph_payment(receipt.total.to_i, @package.photographer_commission, impression_discount_package_for_city)
	receipt.transportion_cost = 0
        # ( receipt.total.to_i * 0.9 ).to_s
        receipt.user = @project.user
      else
        receipt = Receipt.new(total: @project.package.price, subtotal: subtotal_after_discount_city, user: @user)
        ph_payment = receipt.calculate_ph_payment(@project.package.price.to_i, @package.photographer_commission, impression_discount_package_for_city)
        receipt.ph_payment = ph_payment
      end
      receipt.impression_discount_package_for_city = impression_discount_package_for_city

      # add coupon
      coupon = @project.coupon
      if coupon && coupon.is_active
        if coupon.is_percent
          receipt.subtotal = receipt.subtotal.to_i - ((coupon.value.to_i * receipt.total.to_i) / 100)
        else
          receipt.subtotal = receipt.subtotal.to_i - coupon.value.to_i
        end
        # coupon.used_times = coupon.used_times + 1
        coupon.save
        receipt.coupon = coupon
        @project.coupon = coupon
      end
      ActiveRecord::Base.transaction do
        receipt.save
        @project.receipt = receipt
        @project.set_reserve_step("package")
        @project.save
      end
      if params[:photographer].present?
        photographer = Photographer.find_by_uid(params[:photographer])
        direct_city_name = photographer.location.city.name
        render json: { messages: ["پکیج انتخابی با موفقیت اضافه شد"], direct_city_name: direct_city_name, direct_photographer_name: photographer.display_name }, result: "True", status: :accepted
      else
        render json: { messages: ["پکیج انتخابی با موفقیت اضافه شد"] }, result: "True", status: :accepted
      end
    else
      render json: { messages: ["پکیج انتخابی یافت نشد"] }, result: "False", status: :bad_request
    end
  end

  private

  def reserve_params
    params.require(:reserve).permit(:offset_package, :photographer_id, :shoot_type_id, :package_id, :coupon_id, :user_id, :receipt_id, :address_id, :start_time, :delivery_at_location)
  end
end
