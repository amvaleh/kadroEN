ActiveAdmin.register Commission do
  permit_params :title, :value, :value_type

  menu parent: "Shop", priority: 5
  form do |f|
    div class: "well" do
      f.inputs "Create new" do
        f.input :title
        f.input :value
        f.input :value_type, as: :select, collection: Lookup.where(category: "value_type").map { |type| [type.title, type.code] }
      end
    end
    f.actions
  end
end
