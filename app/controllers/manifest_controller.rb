class ManifestController < ApplicationController
  respond_to :json

  def photographer_calendar
    if params[:photographer_mobile_number].present?
      ph = Photographer.find_by(:mobile_number => params[:photographer_mobile_number])
      short_name = "تقویم #{ph.display_name}"
      name = "تقویم #{ph.display_name}"
      theme_color = "#D5E0EB"
      background_color = "#D5E0EB"
      display = "standalone"
      orientation = "portrait"
      icons = [{
        "src": "/img/kadro_calender_logo_512x512.png",
        "type": "image/png",
        "sizes": "512x512",
      },
               {
        "src": "/img/kadro_calender_logo_192x192.png",
        "type": "image/png",
        "sizes": "192x192",
      }]
      start_url = "/photographers/#{ph.slug}/times?utm_source=calender"
      render json: { short_name: short_name, name: name, theme_color: theme_color, background_color: background_color, display: display, orientation: orientation, icons: icons, start_url: start_url }, status: :accepted
    end
  end
end
