module Frames
  class FixFrames
    include Interactor

    FRAME_PATH = "#{Rails.root}/public/uploads/frame/file"

    def call
      ext = File.extname(context.frame.file_name)
      file_uuid = "#{SecureRandom.uuid}#{ext}"
      slug = SecureRandom.base58(24)
      light_version_slug = "#{SecureRandom.base58(24)}#{ext}"

      p "#{FRAME_PATH}/#{context.frame.file.model.id}/#{context.frame.file_name}"
      file_path = "#{FRAME_PATH}/#{context.frame.id}"
      if File.exist?("#{file_path}/#{context.frame.file_name}")
        Frame.where(id: context.frame.id).update_all('original_filename = file')
        Frame.where(id: context.frame.id).update_all(slug: slug,
                                               light_version_slug: light_version_slug,
                                               file: file_uuid,
                                               file_name: file_uuid)
        File.rename("#{file_path}/#{context.frame.file_name}",
                    "#{file_path}/#{file_uuid}")
        light_version = Dir.glob("#{file_path}**/light_*")
        p light_version
        File.rename(light_version[0], "#{file_path}/#{light_version_slug}") if light_version
        FileUtils.mv(file_path, "#{FRAME_PATH}/#{slug}")
      end
    rescue Exception => e
      p e.message
    end
  end
end
