class PhotoUploader < CarrierWave::Uploader::Base
  CarrierWave.configure do |config|
    if Rails.env.development?
      # config.asset_host = "https://app.kadro.me"
    end
  end

  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  # include CarrierWave::MiniMagick
  include CarrierWave::ImageOptimizer

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog
  #

  before :remove, :delete_file

  def delete_file
    if Dir.exist?(File.dirname(self.file.file))
      FileUtils.remove_dir(File.dirname(self.file.file))
    end
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url(*args)
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process scale: [200, 300]

  #

  # def scale(width, height)
  #   # do something
  # end

  #
  #
  version :thumb, from_version: :medium do
    process resize_to_fit: [100, 100]
  end

  version :medium, from_version: :large do
    process resize_to_fit: [1080, 1080]
    # process :quality => 50
    process optimize: [{ quality: 65, quiet: true }]
  end
  #
  #
  version :large do
    process resize_to_fit: [1360, 970]
    process optimize: [{ quality: 65, quiet: true }]
  end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process resize_to_fit: [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_whitelist
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
