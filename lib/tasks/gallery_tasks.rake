namespace :gallery_tasks do
  desc "remove zip file after one week"
  task check_zip_created_at: :environment do
    Gallery.have_zip.each do |gallery|
      if (Time.now - gallery.zip_created_at) >= 7.days
        remove_folder_for_gallery = `rm -rf public/uploads/frames/zip/gallery/#{gallery.slug}`
        gallery.zip_created_at = nil
        gallery.save
      end
    end
  end
end
