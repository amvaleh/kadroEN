ActiveAdmin.register CouponRedemption do
  menu parent: "Coupon", priority: 1
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or

  index do
    selectable_column
    column :id
    column "کد کپن" do |p|
      "#{p.coupon.code}"
    end
    column :coupon
    column :user
    column :receipt
    column "زمان ایجاد" do |p|
      "#{p.created_at}" unless p.created_at.nil?
    end
    column "پرداخت شده" do |p|
      if p.receipt.project.is_payed?
        "بله"
      else
        "خیر"
      end
    end
    actions
  end
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
