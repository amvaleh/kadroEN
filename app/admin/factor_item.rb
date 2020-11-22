ActiveAdmin.register FactorItem do
  permit_params :factor_id, :relation_id, :relation_user, :relation_item

  menu parent: "Coupon", priority: 4
  form do |f|
    div class: "well rtl" do
      f.inputs "Create New" do
        f.input :factor
        f.input :relation_user, collection: User.all
        f.input :relation_item, collection: Item.all
      end
      f.actions
    end
  end
end
