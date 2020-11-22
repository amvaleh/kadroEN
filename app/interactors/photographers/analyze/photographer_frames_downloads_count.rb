module Photographers::Analyze
  class PhotographerFramesDownloadsCount
    include Interactor

    def call
      context.download_number = Project.joins(gallery: :frames)
                                    .where('photographer_id = ?', context.photographer_id).sum('downloaded_times')
    end
  end
end