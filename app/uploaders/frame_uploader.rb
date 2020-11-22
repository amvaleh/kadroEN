class FrameUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  include CarrierWave::ImageOptimizer

  storage :file
  before :cache, :reset_secure_token
  before :cache, :save_original_filename
  before :remove, :delete_file

  def delete_file
    if Dir.exist?(File.dirname(self.file.file))
      FileUtils.remove_dir(File.dirname(self.file.file))
    end
  end

  def store_dir
    if model.section_number.present?
      "uploads/#{model.class.to_s.underscore}/#{model.section_number}/#{model.slug}"
    else
      # "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.slug}"
    end
  end

  def reset_secure_token(file)
    model.image_secure_token = nil
  end

  def save_original_filename(file)
    x = SecureRandom.base58(24) + File.extname(file.original_filename)
    model.light_version_slug = x
    model.original_filename ||= file.original_filename if file.respond_to?(:original_filename)
  end

  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  def secure_token
    media_original_filenames_var = :"@#{mounted_as}_original_filenames"

    unless model.instance_variable_get(media_original_filenames_var)
      model.instance_variable_set(media_original_filenames_var, {})
    end

    unless model.instance_variable_get(media_original_filenames_var).map { |k, v| k }.include? model.original_filename.to_sym
      new_value = model.instance_variable_get(media_original_filenames_var).merge({ "#{model.original_filename}": SecureRandom.uuid })
      model.instance_variable_set(media_original_filenames_var, new_value)
    end

    model.instance_variable_get(media_original_filenames_var)[model.original_filename.to_sym]
  end

  process :store_dimensions

  version :light do
    process :resize_to_limit => [900, 900]
    # process :quality => 65
    process optimize: [{ quality: 65, quiet: true }]

    def full_filename(for_file = model.file)
      x = model.light_version_slug
      "#{x}"
    end
  end

  version :watermarked do
    #process :convert => 'jpg'
    process :resize_to_limit => [900, 900]
    # process :quality => 65
    process optimize: [{ quality: 65, quiet: true }]
    process :watermark

    def watermark
      manipulate! do |img|
        logo = Magick::Image.read("#{Rails.root}/app/assets/images/logoWebWhite.png").first
        img = img.composite(logo, Magick::CenterGravity, Magick::OverCompositeOp)
      end
    end

    def full_filename(for_file = model.file)
      "watermarked_#{model.original_filename}"
    end
  end

  def store_dimensions
    if file && model
      img = Magick::Image::read(file.file).first
      model.width = img.columns
      model.height = img.rows
    end
  end

  private

  def need_watermark?(frame)
    model.gallery.project.package.is_full == false
  end
end
