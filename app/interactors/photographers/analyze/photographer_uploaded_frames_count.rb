module Photographers::Analyze
  class PhotographerUploadedFramesCount
    include Interactor
    def call
      context.frames_number = Project.joins(gallery: :frames)
                                  .where('photographer_id = ?',context.photographer_id).count('1')
    end
  end
end