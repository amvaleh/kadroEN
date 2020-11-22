class EmailSendUrlZipFileDownloadWorker
  include Sidekiq::Worker

  def perform(slug)
    res = GalleryMailer.send_url_zip_file_download(slug).deliver_now
  end
end
