ActiveAdmin.register Credit do
  permit_params :value, :owner_type, :owner_id, :owner

  menu parent: "User", priority: 2

  form do |f|
    f.inputs "NEW" do
      f.input :value
      f.input :owner_type
      f.input :owner_id
    end
    f.actions
  end
end
