ActiveAdmin.register Factor do
  # menu false
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #

  permit_params :title, :relation_type, :factor_type, :value, :value_type, :coupon_id
  menu parent: "Coupon", priority: 3
  index do
    selectable_column
    column :title
    column :relation_type do |f|
      Lookup.find_by(category: "relation_type", code: f.relation_type).title
    end
    column :factor_type do |f|
      Lookup.find_by(category: "factor_type", code: f.factor_type).title
    end
    column :coupon
    column :value
    column :value_type do |f|
      Lookup.find_by(category: "value_type", code: f.value_type).title
    end
    actions
  end

  form do |f|
    div class: "well rtl" do
      f.inputs "Create New" do
        f.input :coupon
        f.input :title
        f.input :relation_type, :as => :select, :collection => Lookup.where(category: "relation_type").map { |type| [type.title, type.code] }
        f.input :factor_type, :as => :select, :collection => Lookup.where(category: "factor_type").map { |type| [type.title, type.code] }
        f.input :value
        f.input :value_type, :as => :select, :collection => Lookup.where(category: "value_type").map { |type| [type.title, type.code] }
      end
      f.actions
    end
  end
end
