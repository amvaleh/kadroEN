# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"
Rails.application.config.assets.precompile << /\.(?:svg|eot|woff|ttf)\z/

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w( locationpicker.jquery.js )
Rails.application.config.assets.precompile += %w( package_style.css )
Rails.application.config.assets.precompile += %w( style.css )
Rails.application.config.assets.precompile += %w( persianDatePicker-default.css )
Rails.application.config.assets.precompile += %w( persianDatePicker.js )
Rails.application.config.assets.precompile += %w( date_style.css )
Rails.application.config.assets.precompile += %w( jquery.magicsearch.js )
Rails.application.config.assets.precompile += %w( jquery.magicsearch.scss )
Rails.application.config.assets.precompile += %w( bootstrap.min.js )
# drop down
Rails.application.config.assets.precompile += %w( semantic.min.js )
Rails.application.config.assets.precompile += %w( semantic.min.css )
# fileupload
Rails.application.config.assets.precompile += %w( jquery-fileupload.js )
Rails.application.config.assets.precompile += %w( jquery.fileupload.css )
Rails.application.config.assets.precompile += %w( jquery.fileupload-ui.css )
# kadro template
Rails.application.config.assets.precompile += %w( kadro/kadro.css )
Rails.application.config.assets.precompile += %w( kadro/kadro.js )

# kadro book
Rails.application.config.assets.precompile += %w( book.css )
Rails.application.config.assets.precompile += %w( book.js )
# cloudinary
Rails.application.config.assets.precompile += %w( jquery.ui.widget.js )
Rails.application.config.assets.precompile += %w( jquery.iframe-transport.js )
Rails.application.config.assets.precompile += %w( jquery.fileupload.js )
Rails.application.config.assets.precompile += %w( jquery.cloudinary.js )
# gallery layout
Rails.application.config.assets.precompile += %w( gallery/gallery.css )
Rails.application.config.assets.precompile += %w( gallery/gallery.js )
# Photographer template
Rails.application.config.assets.precompile += %w( photographers.css )
# new uploader
Rails.application.config.assets.precompile += %w( plupload.full.min.js )
Rails.application.config.assets.precompile += %w( jquery.plupload.queue.min.js )
Rails.application.config.assets.precompile += %w( jquery.plupload.queue.css )
# new uploader - cubeportfolio
Rails.application.config.assets.precompile += %w( jquery.cubeportfolio.min.js )
# cubeportfolio for gallery
Rails.application.config.assets.precompile += %w( gallery/cubeportfolio.min.css )
Rails.application.config.assets.precompile += %w( gallery/jquery.cubeportfolio.min.js )

Rails.application.config.assets.precompile += %w( join.css )
Rails.application.config.assets.precompile += %w( join.js )

Rails.application.config.assets.precompile += %w( chartkick.js )

Rails.application.config.assets.precompile += %w( gifts/gifts.css )
Rails.application.config.assets.precompile += %w( gifts/gifts.js )

# kadro wodpress
Rails.application.config.assets.precompile += %w( wordpress.css )
Rails.application.config.assets.precompile += %w( wordpress.js )

# kadro wodpress
Rails.application.config.assets.precompile += %w( videography.scss )
Rails.application.config.assets.precompile += %w( videography.js )

# kadro shoot_locations
Rails.application.config.assets.precompile += %w( shoot_locations.css )
Rails.application.config.assets.precompile += %w( shoot_locations.js )

Rails.application.config.assets.precompile += %w( twentytwenty/twentytwenty.css )
Rails.application.config.assets.precompile += %w( twentytwenty/jquery.event.move.js )
Rails.application.config.assets.precompile += %w( twentytwenty/jquery.twentytwenty.js )

# gallery dashboard
Rails.application.config.assets.precompile += %w( dashboard.css )
Rails.application.config.assets.precompile += %w( dashboard.js )
