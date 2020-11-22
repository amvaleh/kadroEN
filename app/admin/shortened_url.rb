ActiveAdmin.register Shortener::ShortenedUrl do

  permit_params :url, :expires_at

  form do |f|
    f.inputs 'Url' do
      f.input :url
      f.input :expires_at, as: :date_time_picker
    end

    f.actions
  end
  menu false
end
