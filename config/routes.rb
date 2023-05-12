Rails.application.routes.draw do
  mount Lines::Engine => "/updates"
  # constraints subdomain: "app" do
  #   # get "/" => "bookv2#show", as: "app"
  #   get "callbook" => "bookv2#callbook", as: "callbook"
  #   get "free_times/:id/close_all", to: "free_times#close_all", as: "close_all_times"
  #   get "free_times/:id/open_most", to: "free_times#open_most", as: "open_most_times"
  #   get "free_times/:id/open_optimum", to: "free_times#open_optimum", as: "open_optimum_times"
  #   get "partner/show"
  #   get "photographers/apply"
  #   get "photographers/welcome"
  #   get "photographers/join"

  #   devise_for :admin_users, ActiveAdmin::Devise.config
  #   ActiveAdmin.routes(self) rescue ActiveAdmin::DatabaseHitDuringLoad
  #   devise_for :photographers, path: "photographers", controllers: { sessions: "photographers/sessions", registrations: "photographers/registrations", passwords: "photographers/passwords", confirmations: "photographers/confirmations" }
  #   devise_for :users, path: "users", controllers: { sessions: "users/sessions", registrations: "users/registrations", passwords: "users/passwords" }

  #   post "share_controll/create"
  #   post "share_controll/allow"
  #   post "share_controll/disallow"
  #   get "gifts/happy_photographers_day"
  #   get "user_feedbacks/:id", to: "user_feedbacks#show", as: "user_feedbacks"
  #   post "user_feedbacks/:id", to: "user_feedbacks#create", as: "create_user_feedbacks"
  #   get "feed_backs/:id", to: "feed_backs#dashboard_show", as: "feed_backs"
  #   post "feed_backs/:id", to: "feed_backs#create", as: "create_feed_backs"
  #   post "maps/photographer_filter" => "maps#photographer_filter", as: "photographer_filter"
  #   post "maps/photographer_filter_with_distance" => "maps#photographer_filter_with_distance", as: "photographer_filter_with_distance"
  #   post "expertises/receive_photo" => "expertises#receive_photo", as: "receive_photo_expertise"
  #   get "prophotographers/show"
  #   get "galleries/load_more", to: "galleries#load_more", as: "load_more"
  #   get "galleries/load_more_dashboard", to: "galleries#load_more_dashboard", as: "load_more_dashboard"
  #   get "projects/set_first_call/:id", to: "projects#set_first_call", as: "set_first_call"
  #   get "projects/not_answered/:id", to: "projects#not_answered", as: "not_answered"
  #   get "projects/sms_link/:id", to: "projects#sms_link_to_user", as: "sms_link"
  #   get "photographers/reject/:id", to: "photographers#reject", as: "reject_photographer"
  #   get "photographers/i_called/:id", to: "photographers#set_first_call", as: "i_called_photographer"
  #   post "photographers/settlement"
  #   patch "/coupons", to: "coupons#batch"
  #   get "/coupons/apply", to: "coupons#apply", as: "apply_coupon", format: "json"
  #   post "activities/activities_filter" => "activities#activities_filter", as: "activities_filter"
  #   get "galleries/my_invoices" => "galleries#invoices", as: "user_invoices"
  #   get "galleries/my_invoices_dashboard" => "galleries#invoices_dashboard", as: "user_invoices_dashboard"
  #   get "galleries/download_receipt" => "galleries#download_receipt", as: "download_receipt"
  #   get "galleries/receipt_modal" => "galleries#receipt_modal"
  #   get "galleries/receipt_modal_dashboard" => "galleries#receipt_modal_dashboard"
  #   post "page_setting/set_order_of_expertise", to: "photographers#set_order_of_expertise", as: "set_order_of_expertise"
  #   post "page_setting/remove_avatar", to: "photographers#remove_avatar"
  #   get "/api" => redirect("/swagger-ui/dist/index.html?url=/apidocs/api-docs.json")

  #   namespace :api do
  #     namespace :v1 do
  #       resources :projects
  #       resources :authentication, only: [:create]
  #       resources :photographers do
  #         resources :reservations, only: [:create]
  #       end
  #       resources :free_times, only: [:index, :create]
  #       resources :users, only: [:create]
  #       resources :locations, only: [:create]
  #       resources :photos, only: [:create, :destroy]
  #       resources :expertises, only: [:destroy, :index]
  #       resources :experiences, only: [:create]
  #       resources :equipments, only: [:create]
  #       post "update_user", to: "users#update_user"

  #       post "filter_photographers", to: "photographers#filter_photographers"
  #       get "photographers_photos", to: "photographers#photos"
  #       post "photographers_portfolio", to: "photographers#portfolio"
  #       post "available_photographer", to: "photographers#available_photographer"
  #       get "user_comments", to: "photographers#user_comments"
  #       get "feed_backs", to: "photographers#feed_backs"
  #       post "submit_shoot_type", to: "reservations#submit_shoot_type"
  #       post "submit_shoot_type", to: "reservations#submit_shoot_type", via: :options
  #       post "submit_package", to: "reservations#submit_package"
  #       post "submit_address", to: "reservations#submit_address"
  #       post "check_coupon", to: "reservations#check_coupon"
  #       post "available_hours", to: "free_times#available_hours"
  #       post "submit_photographer", to: "reservations#submit_photographer"
  #       post "submit_detail", to: "reservations#submit_detail"
  #       post "submit_delivery_at_location", to: "reservations#submit_delivery_at_location"
  #       post "pay", to: "payments#pay"
  #     end
  #     namespace :v2 do
  #       post "available_photographer", to: "photographers#available_photographer"
  #       post "available_hours", to: "free_times#available_hours"
  #       post "available_photographer_hours", to: "free_times#available_photographer_hours"
  #       post "submit_photographer", to: "projects#submit_photographer"
  #       resources :users, only: [:create]
  #       post "update_user", to: "users#update_user"
  #       get "active_cities", to: "locations#active_cities"
  #       post "switched_direct_photographer", to: "photographers#switched_direct_photographer"
  #     end
  #     namespace :v3 do
  #       resources :authentication, only: [:create]
  #       post "submit_address", to: "addresses#submit_address"
  #       post "accept_address", to: "addresses#accept_address"
  #       post "submit_shoot_type", to: "shoot_types#submit_shoot_type"
  #       post "accept_shoot_type", to: "shoot_types#accept_shoot_type"
  #       post "submit_package", to: "packages#submit_package"
  #       get "give_all_studios", to: "shoot_locations#give_all_studios"
  #       get "give_all_locations", to: "shoot_locations#give_all_locations"
  #       resources :users, only: [:create]
  #       post "give_users", to: "users#give_users", as: "give_users"
  #       post "give_projects_slug", to: "projects#give_projects_slug", as: "give_projects_slug"
  #       post "generate_password", to: "users#generate_password", as: "generate_password"
  #     end
  #     namespace :v4 do
  #       resources :authentication, only: [:create]
  #       get "shoot_types", to: "shoot_types#index"
  #       get "shoot_locations", to: "shoot_locations#index"
  #       get "packages", to: "packages#index"
  #       get "available_hours", to: "free_times#available_hours"
  #       post "submit_package", to: "packages#submit_package"
  #       get "give_all_studios", to: "shoot_locations#give_all_studios"
  #       get "give_all_locations", to: "shoot_locations#give_all_locations"
  #       resources :users, only: [:create]
  #       post "give_users", to: "users#give_users", as: "give_users"
  #       post "give_projects_slug", to: "projects#give_projects_slug", as: "give_projects_slug"
  #       post "generate_password", to: "users#generate_password", as: "generate_password"
  #     end
  #   end

  #   get "scanned_profile/has_scanned_profile/:id", to: "scanned_profiles#has_scanned_profile", as: "has_scanned_profile"
  #   get "mailview/order_recieved"
  #   get ":business_id/projects/package", to: "projects#package", as: "business_projects"
  #   get ":photographer_id/direct_reserve", to: "projects#package", as: "direct_reserve"
  #   get "password_form", to: "galleries#password_form", as: :gallery_password_form
  #   post "password_create", to: "galleries#password_create", as: :gallery_password_create
  #   get "clear_password/:id", to: "galleries#clear_password", as: :gallery_clear_password
  #   get "cart_form", to: "carts#cart_form", as: :cart_form
  #   get "cart_form_dashboard", to: "carts#cart_form_dashboard", as: :cart_form_dashboard
  #   get "cart_create", to: "carts#cart_create", as: :cart_create
  #   get "cart_items_list", to: "carts#cart_items_list", as: :cart_items_list
  #   get "cart_items_list_dashboard", to: "carts#cart_items_list_dashboard", as: :cart_items_list_dashboard
  #   get "cart_update", to: "carts#cart_update", as: :cart_update
  #   get "cart_update_dashboard", to: "carts#cart_update_dashboard", as: :cart_update_dashboard
  #   get "add_description_to_cart_item", to: "carts#add_description_to_cart_item", as: :add_description_to_cart_item
  #   get "add_description_to_cart_item_dashboard", to: "carts#add_description_to_cart_item_dashboard", as: :add_description_to_cart_item_dashboard
  #   delete "cart_clear", to: "carts#cart_clear", as: :cart_clear
  #   delete "cart_item_delete", to: "carts#cart_item_delete", as: :cart_item_delete
  #   delete "cart_item_delete_dashboard", to: "carts#cart_item_delete_dashboard", as: :cart_item_delete_dashboard
  #   get "invoice_form", to: "invoices#invoice_form", as: :invoice_form
  #   get "invoice_form_dashboard", to: "invoices#invoice_form_dashboard", as: :invoice_form_dashboard
  #   get "invoice_coupon", to: "invoices#invoice_coupon", as: :invoice_coupon
  #   post "shipping_address_create", to: "invoices#shipping_address_create", as: :shipping_address_create
  #   post "invoice_create", to: "invoices#invoice_create", as: :invoice_create
  #   match "invoice_pay" => "invoices#invoice_pay", via: :post
  #   match "invoice_pay" => "invoices#invoice_pay", via: :get
  #   get "invoices/:vch_number/verify_pay" => "invoices#verify_pay"
  #   get "payment_result", to: "invoices#payment_result", as: :payment_result
  #   get "invoice_show", to: "invoices#invoice_show", as: :invoice_show
  #   get "create_zip", to: "invoices#create_zip", as: :create_zip
  #   post "coupon", to: "invoices#check_coupon", as: :coupon_factor
  #   post "clear_coupon", to: "invoices#delete_coupon", as: :delete_coupon
  #   get "do_pay_form", to: "invoices#do_pay_form", as: :do_pay_form
  #   get "do_pay_form_dashboard", to: "invoices#do_pay_form_dashboard", as: :do_pay_form_dashboard
  #   get "invoices/zero_payment_invoice"
  #   get "projects/:id/verify_pay", to: "projects#verify_pay", as: :verify_extra_hour_pay
  #   get "where_do_you_need", to: "reserve#shoot_location"
  #   get "what_do_you_need", to: "reserve#what_do_you_need"
  #   get "when_do_you_need", to: "reserve#when_do_you_need"
  #   get "pick_photographer", to: "reserve#pick_photographer"
  #   get "reserve/shoot_location"
  #   get "reserve/initiate"
  #   post "reserve/submit_location"
  #   post "reserve/submit_detail"
  #   post "reserve/package"
  #   post "reserve/submit_location_date"
  #   post "reserve/submit_photographer"
  #   post "reserve/pay"
  #   post "reserve/day_start_hours"
  #   post "reserve/check_coupon"
  #   post "projects/debit_check"
  #   post "reserve/submit_extra_hour"
  #   get "zarinpal" => "main#pay"
  #   match "/pay" => "zarinpal#pay", via: :post
  #   match "/pay" => "zarinpal#pay", via: :get
  #   get "zarinpal/:id" => "zarinpal#verify"
  #   match "/extrahour_pay" => "zarinpal#extrahour_pay", via: :post
  #   match "/extrahour_pay" => "zarinpal#extrahour_pay", via: :get
  #   get "extrahour_zarinpal/:id" => "zarinpal#extrahour_verify"
  #   get "frames/:id/download" => "frames#download", as: "download_frame"
  #   get "frames/check" => "frames#check_if_downloaded"
  #   get "frames/get_id" => "frames#get_id"
  #   post "frames/like" => "frames#like", as: "like_frame"
  #   get "frames/:id/expiring_link" => "frames#expiring_link", as: "frame_url"
  #   post "selectable_images/like" => "selectable_images#like", as: "like_selectable_image"
  #   post "selectable_images/create" => "selectable_images#create", as: "create_selectable"
  #   post "widgets/submit_photographer_widget" => "widgets#submit_photographer_widget", as: "submit_photographer_widget"
  #   post "photographers/new_form_widget" => "photographers#new_form_widget", as: "new_form_widget"
  #   get "book", to: "bookv2#show"
  #   get "book_v1", to: "book#show"
  #   get "users/register"
  #   post "users/check_number"
  #   get "check_number_again", to: "users#check_number_again", as: :check_number_again
  #   get "users/update_info"
  #   get "users/refer"
  #   get "users/refer_dashboard"
  #   post "users/set_call_date", to: "users#set_call_date", as: "set_call_date"
  #   post "users/is_called", to: "users#is_called", as: "user_is_called"
  #   post "users/set_birthday_date", to: "users#set_birthday_date", as: "set_birthday_date"
  #   post "users/update", to: "users#update", as: "update_user"
  #   get "photographer_calendar_manifest", to: "manifest#photographer_calendar"

  #   resources :expertise_widget_attachments
  #   resources :expertise_widgets
  #   resources :widgets
  #   resources :frames
  #   resources :calls
  #   resources :photos do
  #     collection do
  #       get "photo_content"
  #     end
  #   end
  #   resources :scanned_profiles, only: [:show, :create, :destroy]
  #   resources :shoot_location_attachments, only: [:create, :destroy]
  #   get "/galleries", to: "galleries#complete_project"
  #   get "/galleries/reserved", to: "galleries#reserved_projects"
  #   get "/galleries/not_payed", to: "galleries#not_payed_projects"
  #   post "/galleries/update_name", to: "galleries#update_name", as: "update_gallery_name"
  #   get "/galleries/profile", to: "galleries#profile"
  #   get "/galleries/:id", to: "galleries#show_dashboard"

  #   resources :galleries, only: [:edit, :create, :destroy] do
  #     member do
  #       get "permission", to: "galleries#share_list_dashboard"
  #       post "upload", to: "uploader#new"
  #       post "uploadframe", to: "uploader#uploadframe"
  #       get "single_frame"
  #       post "zip_download"
  #       post "exempt_photographer_money"
  #       post "upload_done"
  #       post "transfer"
  #       post "release_payment"
  #       get "authenticate_user", as: :authenticate_user
  #       post "check_password", as: :check_password
  #       get "profile"
  #     end
  #   end
  #   resources :projects do
  #     collection do
  #       get "package"
  #     end
  #     member do
  #       get "where_and_when"
  #       get "photographer"
  #       get "details"
  #       get "receipt"
  #       get "success_credit_settlement"
  #       get "thank_you"
  #       get "gracias"
  #       get "project_information", as: :project_information
  #       get "alternate_photographers"
  #       get "extra_hour"
  #       get "extra_receipt"
  #       post "ph_approval"
  #       get "success_payment_notification"
  #       get "set_delivery_at_location", as: :deliver_at_location
  #       post "release_payment"
  #     end
  #   end
  #   resources :transactions do
  #     collection do
  #       post "initial_send"
  #       post "nailedit"
  #       match "/do_verify", to: "transactions#do_verify", as: :do_verify, via: [:get, :post]
  #     end
  #   end
  #   resources :photographers do
  #     member do
  #       get "studio_locations", to: "photographers#studio_locations", as: "studio_locations"
  #       post "submit_studio_locations", to: "photographers#submit_studio_locations"
  #       get "page_setting", to: "photographers#page_setting"
  #       get "pro", to: "prophotographers#show"
  #       get "show"
  #       get "studio"
  #       get "done"
  #       get "portfolio"
  #       get "experience"
  #       get "equipments"
  #       post "submit_basic_info"
  #       post "submit_equipment"
  #       post "submit_experience"
  #       post "submit_portfolio"
  #       post "receive_photo"
  #       get "projects"
  #       get "remove_expertise"
  #       get "times"
  #       get "to_shares"
  #       get "edit_info"
  #       get "shoot_type_manage/:shoot_type_title", to: "photographers#edit_photographer_shoot_type", as: "edit_shoot_type"
  #       post "update_info"
  #       post "update_times"
  #       get "bank_account"
  #       get "checkout"
  #       post "update_bank_account"
  #       post "submit_avatars"
  #       post "remove_avatar"
  #       get "register_sn", to: "photographers#register_serial_number"
  #       post "register_sn", to: "photographers#register_serial_number"
  #       get "payments", to: "photographers#payments_detail"
  #       get "details", to: "photographers#shop_details"
  #       post "project_search", to: "photographers#project_search", as: :project_search
  #       get "candidated_for", to: "photographers#projects_of_candidate"
  #       get "load_more", to: "photographers#load_more_projects_you_candidated"
  #       post "confirm_my_email", as: "confirm_my_email"
  #     end
  #   end

  #   mount Blazer::Engine, at: "kadro_blazer"
  #   mount Lines::Engine => "/updates", as: "updates"
  #   match "*a", :to => "application#page_not_found", via: :get
  #   # App Constraint
  # end

  # constraints subdomain: "locations" do
  #   root to: "shoot_locations#index", as: "shoot_location_root"
  #   get "/list", to: "shoot_locations#index", as: "shoot_location_list"
  #   get "/:id", to: "shoot_locations#show", as: "shoot_location_show"
  #   get "/shoot_type/:shoot_type", to: "shoot_locations#shoot_type_filter", as: "shoot_location_shoot_type_filter"
  #   get "/location_type/:id", to: "shoot_locations#shoot_location_type", as: "shoot_location_type_filter"
  #   match "*a", :to => "application#page_not_found", via: :get
  # end

  # constraints subdomain: "pro" do
  #   get "/" => "prophotographers#index2", as: "all_pros"
  #   get "/list" => "prophotographers#index2"
  #   get "/city/:city_name", to: "prophotographers#city_list", as: "city"
  #   get "/city/:city_name/expertise/:shoot_type", to: "prophotographers#city_expertise_list", as: "city_expertise"
  #   get "/expertise/:shoot_type", to: "prophotographers#expertise_list", as: "expertise_only"
  #   get "/:id", to: "prophotographers#show", as: "pro"
  #   get "/:id", to: "prophotographers#show", as: "prophotographer_show"
  #   get "/:id/call", to: "prophotographers#call", as: "call_photographer"
  #   post "/query", to: "prophotographers#query", as: "query_pro_photographers"
  #   match "*a", :to => "application#page_not_found", via: :get
  #   post "selectable_images/like" => "selectable_images#like", as: "pro_like_selectable_image"
  #   post "selectable_images/create" => "selectable_images#create", as: "pro_create_selectable"
  # end

  constraints(ShortenedLink) do
    get "/:id" => "shortener/shortened_urls#show"
  end

  constraints(SubdomainRequired) do
    get "/" => "subdomain#show"
  end

  defaults :subdomain => false do
    get "home", to: "public#home", as: "home"
    get "contact_us", to: "public#contact_us"
    get "contact", to: "public#contact_us"
    get "about_us", to: "public#about_us"
    get "join_us", to: "public#join_us"
    get "join-kadro-photographers", to: "public#join_us", as: "join"
    get "pricing", to: "public#pricing"
    # get "print_prices", to: "public#print_prices"
    # get "print-prices", to: "public#print_prices"
    # get "terms", to: "public#terms"
    # get "privacy", to: "public#privacy"
    # get "faq", to: "public#faq"
    # get "enterprises", to: "public#enterprises"
    # get "affiliate", to: "public#affiliate"
    # get "backstages", to: "public#backstages"
    # get "news", to: "public#news"
    # get "standard_edit", to: "public#standard_edit"
    # get "retouch_edit", to: "public#retouch_edit"
    # get "videography/:id", to: "videography#show", as: "video"
    # get "videography/", to: "videography#index", as: "videography"
    get "types", to: "types#index", as: "types"
    get "types/:title", to: "types#show", as: "types_show"
    # get "submit-project", to: "video_leads#new", as: "new_video_leads"
    # post "submit-project", to: "video_leads#create", as: "create_video_leads"
    post "selectable_images/like" => "selectable_images#like", as: "kd_like"
    get "single_photo", to: "selectable_images#single_photo", as: "single_photo"

    root to: "public#home"
    get "/", to: "public#home", as: "kadro"
  end
  post "call_request" => "public#create_call_request", as: "create_call_request"
  get "call_request" => "public#call_request", as: "call_request"

  post "subscribers", to: "public#create_subscribers", as: "create_subscribers"

  # get "/" => "public#home", as: "home"

  get "/404", :to => "application#page_not_found"
  get "/500", :to => "application#page_not_found"
  get "/422", :to => "application#page_not_found"
  match "*a", :to => "application#page_not_found", via: :get
end
