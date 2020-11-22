module Frames
  class RecreateVersion
    include Interactor

    def call
      frames = Frame.where('public_id is null').load
      frames.each do |frame|
        Rails.logger.info("Recreate frame: #{frame.file_name}")
        begin
          frame.file.recreate_versions!
        rescue Exception => e
          Rails.logger.info(e.message)
        end
      end
    end
  end
end