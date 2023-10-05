ActiveAdmin.setup do |config|
  # == Site Title
  #
  # Set the title that is displayed on the main layout
  # for each of the active admin pages.
  #
  config.site_title = "ShootEmpire HQ"
  config.comments_menu = { parent: "General Settings", priority: 1 }

  meta_tags_options = { viewport: "width=device-width, initial-scale=1" }
  config.meta_tags = meta_tags_options
  config.meta_tags_for_logged_out_pages = meta_tags_options

  config.namespace :admin do |admin|
    admin.build_menu do |menu|
      menu.add label: "ShootLocations", priority: 0
      menu.add label: "General Settings", priority: 1
      menu.add label: "Project", priority: 2
      menu.add label: "User", priority: 3
      menu.add label: "Shop", priority: 4
      menu.add label: "Dashboard", priority: 5
      menu.add label: "Photographer", priority: 6
      menu.add label: "Coupon", priority: 7

      # menu.add label: "Kadro Land", priority: 1 do |sites|
      #   sites.add label: "Shoot Locations", priority: 1,
      #             url: "/admin/shoot_locations"
      #   sites.add label: "Types of locations", priority: 2,
      #             url: "/admin/shoot_location_types"
      #   sites.add label: "proper shoot types", priority: 3,
      #             url: "/admin/shoot_type_locations"
      # end
      # menu.add label: "General Settings", priority: 2 do |sites|
      #   sites.add label: "Setting", priority: 1,
      #             url: "/admin/settings"
      #   sites.add label: "Redirector", priority: 2,
      #             url: "/admin/redirect_rules"
      #   sites.add label: "Admin User", priority: 5,
      #             url: "/admin/admin_users"
      #   sites.add label: "Shoot Type", priority: 6,
      #             url: "/admin/shoot_types"
      #   sites.add label: "Partner", priority: 7,
      #             url: "/admin/partners"
      #   sites.add label: "Shoot Type Partner", priority: 8,
      #             url: "/admin/shoot_type_partners"
      #   sites.add label: "Business", priority: 9,
      #             url: "/admin/businesses"
      #   sites.add label: "Cities", priority: 10,
      #             url: "/admin/cities"
      #   sites.add label: "Relevants", priority: 11,
      #             url: "/admin/relevants"
      #   sites.add label: "call_status", priority: 12, url: "/admin/call_statuses"
      #   sites.add label: "Feedback Channel", priority: 13,
      #             url: "/admin/feedback_channels"
      #   sites.add label: "Join Step", priority: 14,
      #             url: "/admin/join_steps"
      #   sites.add label: "Service Step", priority: 15,
      #             url: "/admin/service_steps"
      #   sites.add label: "ActiveAdminComment", priority: 16,
      #             url: "/admin/active_admin_comments"
      #   sites.add label: "Lookups", priority: 17,
      #             url: "/admin/lookups"
      #   sites.add label: "Permission", priority: 18,
      #             url: "/admin/permissions"
      #   sites.add label: "SelectableImage", priority: 19,
      #             url: "/admin/selectable_images"
      #   sites.add label: "Share Control", priority: 20,
      #             url: "/admin/share_controls"
      #   sites.add label: "ShortenedUrl", priority: 21,
      #             url: "/admin/shortened_urls"
      #   sites.add label: "UserFeedbackQuestion", priority: 22,
      #             url: "/admin/user_feedback_questions"
      # end
      # menu.add label: "USERS", priority: 3 do |sites|
      #   sites.add label: "users", priority: 1, url: "/admin/users"
      #   sites.add label: "subscribers", priority: 2, url: "/admin/subscribers"
      #   sites.add label: "credits", priority: 3, url: "/admin/credits"
      #   sites.add label: "credit_details", priority: 4, url: "/admin/credit_details"
      #   sites.add label: "credit_detail_types", priority: 5, url: "/admin/credit_detail_types"
      #   sites.add label: "lead_sources", priority: 6, url: "/admin/lead_sources"
      #   sites.add label: "refers", priority: 7, url: "/admin/refers"
      # end
      # menu.add label: "ShopModule", priority: 4 do |sites|
      #   sites.add label: "invoices", priority: 2, url: "/admin/invoices"
      #   sites.add label: "inovice_items", priority: 2, url: "/admin/invoice_items"
      #   sites.add label: "carts", priority: 3, url: "/admin/carts"
      #   sites.add label: "cart_items", priority: 4, url: "/admin/cart_items"
      #   sites.add label: "items", priority: 5, url: "/admin/items"
      #   sites.add label: "item_types", priority: 6, url: "/admin/item_types"
      #   sites.add label: "commissions", priority: 6, url: "/admin/commissions"
      # end
      # menu.add label: "dashboards", priority: 5 do |sites|
      #   sites.add label: "Dashboard", priority: 2, url: "/admin/dashboard"
      #   sites.add label: "Analyze", priority: 2, url: "/admin/analyze"
      #   sites.add label: "Ph Maps", priority: 3, url: "/admin/photographer_maps"
      #   sites.add label: "Activities", priority: 4, url: "/admin/activities"
      #   sites.add label: "Ahoy Events", priority: 5, url: "/admin/ahoy_events"
      #   sites.add label: "Ahoy Visits", priority: 6, url: "/admin/ahoy_visits"
      #   sites.add label: "Sale Analyze", priority: 1, url: "/admin/sale_analyze"
      # end
      # menu.add label: "PHOTOGRAPHERS", priority: 6 do |sites|
      #   sites.add label: "photographers", priority: 1, url: "/admin/photographers"
      #   sites.add label: "free_times", priority: 2,
      #             url: "/admin/free_times_histories"
      #   sites.add label: "widgets", priority: 3,
      #             url: "/admin/widgets"
      #   sites.add label: "Free time histories", priority: 11,
      #             url: "/admin/free_times_histories"
      #   sites.add label: "scanned_profile", priority: 10,
      #             url: "/admin/scanned_profiles"
      #   sites.add label: "User Feedback", priority: 9,
      #             url: "/admin/user_feedbacks"
      #   sites.add label: "Calls", priority: 8,
      #             url: "/admin/calls"
      #   sites.add label: "Grade", priority: 4,
      #             url: "/admin/grades"
      #   sites.add label: "address", priority: 7,
      #             url: "/admin/addresses"
      #   sites.add label: "Equipment", priority: 12,
      #             url: "/admin/equipment"
      #   sites.add label: "PhotographerAttachment", priority: 12,
      #             url: "/admin/photographer_attachments"
      #   sites.add label: "Experience", priority: 13,
      #             url: "/admin/experiences"
      #   sites.add label: "Expertise", priority: 14,
      #             url: "/admin/expertises"
      #   sites.add label: "ExpertiseWidget", priority: 15,
      #             url: "/admin/expertise_widgets"
      #   sites.add label: "ExpertiseWidgetAttachment", priority: 16,
      #             url: "/admin/expertise_widget_attachments"
      #   sites.add label: "Photo", priority: 17,
      #             url: "/admin/photos"
      #   sites.add label: "Camera", priority: 18,
      #             url: "/admin/cameras"
      #   sites.add label: "Lenz", priority: 19,
      #             url: "/admin/lenzs"
      #   sites.add label: "Equip Camera", priority: 20,
      #             url: "/admin/equip_cameras"
      #   sites.add label: "Equip Lenz", priority: 21,
      #             url: "/admin/equip_lenzs"
      #   sites.add label: "Location", priority: 21,
      #             url: "/admin/locations"
      #   sites.add label: "Shoot Location", priority: 22,
      #             url: "/admin/shoot_locations"
      #   sites.add label: "Shoot Location Type", priority: 22,
      #             url: "/admin/shoot_location_types"
      #   sites.add label: "Shoot Type Location", priority: 22,
      #             url: "/admin/shoot_type_locations"
      #   sites.add label: "Bank Account", priority: 23,
      #             url: "/admin/bank_accounts"
      #   sites.add label: "Kit", priority: 24,
      #             url: "/admin/kits"
      #   sites.add label: "Photography Tool", priority: 25,
      #             url: "/admin/photography_tools"
      #   sites.add label: "EquipmentKit", priority: 26,
      #             url: "/admin/equipment_kits"
      #   sites.add label: "Kit Photography Tool", priority: 27,
      #             url: "/admin/kit_photography_tools"
      #   sites.add label: "Feedback Questions", priority: 28,
      #             url: "/admin/feedback_questions"
      # end
      # menu.add label: "COUPONS", priority: 10 do |sites|
      #   sites.add label: "coupons", priority: 1,
      #             url: "/admin/coupons"
      #   sites.add label: "CouponRedemption", priority: 2,
      #             url: "/admin/coupon_redemptions"
      #   sites.add label: "CouponShootType", priority: 2,
      #             url: "/admin/coupon_shoot_types"
      #   sites.add label: "factors", priority: 3,
      #             url: "/admin/factors"
      #   sites.add label: "factor items", priority: 4,
      #             url: "/admin/factor_items"
      #   sites.add label: "invoice factors", priority: 5,
      #             url: "/admin/invoice_factors"
      # end
      # menu.add label: "PROJECTS", priority: 3 do |sites|
      #   sites.add label: "CRM Panel", priority: 1,
      #             url: "/admin/crm"
      #   sites.add label: "projects", priority: 1,
      #             url: "/admin/projects"
      #   sites.add label: "Receipts", priority: 4,
      #             url: "/admin/receipts"
      #   sites.add label: "project_candidates", priority: 3,
      #             url: "/admin/project_candidates"
      #   sites.add label: "Feedbacks", priority: 4,
      #             url: "/admin/feed_backs"
      #   sites.add label: "frames", priority: 20,
      #             url: "/admin/frames"
      #   sites.add label: "exifs", priority: 19,
      #             url: "/admin/exifs"
      #   sites.add label: "PhotoMaterial", priority: 18,
      #             url: "/admin/photomaterial"
      #   sites.add label: "Receipts", priority: 5,
      #             url: "/admin/receipts"
      #   sites.add label: "Packages", priority: 2,
      #             url: "/admin/packages"
      #   sites.add label: "Guidelines", priority: 3,
      #             url: "/admin/guidelines"
      #   sites.add label: "Guideline Packages", priority: 3,
      #             url: "/admin/guideline_packages"
      #   sites.add label: "Start Hour", priority: 19,
      #             url: "/admin/start_hours"
      #   sites.add label: "Categori", priority: 17,
      #             url: "/admin/categories"
      #   sites.add label: "Day Time", priority: 16,
      #             url: "/admin/day_times"
      #   sites.add label: "Week Day", priority: 17,
      #             url: "/admin/week_days"
      #   sites.add label: "------emails-------"
      #   sites.add label: "Photographer", priority: 6,
      #             url: "/admin/sent_photographer_emails"
      #   sites.add label: "Photographer Open", priority: 7,
      #             url: "/admin/sent_photographer_email_opens"
      #   sites.add label: "Project", priority: 8,
      #             url: "/admin/sent_project_emails"
      #   sites.add label: "Project Open", priority: 9,
      #             url: "/admin/sent_project_email_opens"
      # end
    end
  end

  # Set the link url for the title. For example, to take
  # users to your main site. Defaults to no link.
  #
  # config.site_title_link = "/"

  # Set an optional image to be displayed for the header
  # instead of a string (overrides :site_title)
  #
  # Note: Aim for an image that's 21px high so it fits in the header.
  #
  # config.site_title_image = "logo.png"

  # == Default Namespace
  #
  # Set the default namespace each administration resource
  # will be added to.
  #
  # eg:
  #   config.default_namespace = :hello_world
  #
  # This will create resources in the HelloWorld module and
  # will namespace routes to /hello_world/*
  #
  # To set no namespace by default, use:
  #   config.default_namespace = false
  #
  # Default:
  # config.default_namespace = :admin
  #
  # You can customize the settings for each namespace by using
  # a namespace block. For example, to change the site title
  # within a namespace:
  #
  #   config.namespace :admin do |admin|
  #     admin.site_title = "Custom Admin Title"
  #   end
  #
  # This will ONLY change the title for the admin section. Other
  # namespaces will continue to use the main "site_title" configuration.

  # == User Authentication
  #
  # Active Admin will automatically call an authentication
  # method in a before filter of all controller actions to
  # ensure that there is a currently logged in admin user.
  #
  # This setting changes the method which Active Admin calls
  # within the application controller.
  config.authentication_method = :authenticate_admin_user!
  config.skip_before_action :track_ahoy_visit

  # == User Authorization
  #
  # Active Admin will automatically call an authorization
  # method in a before filter of all controller actions to
  # ensure that there is a user with proper rights. You can use
  # CanCanAdapter or make your own. Please refer to documentation.
  config.authorization_adapter = ActiveAdmin::CanCanAdapter

  # In case you prefer Pundit over other solutions you can here pass
  # the name of default policy class. This policy will be used in every
  # case when Pundit is unable to find suitable policy.
  # config.pundit_default_policy = "MyDefaultPunditPolicy"

  # You can customize your CanCan Ability class name here.
  # config.cancan_ability_class = "Ability"

  # You can specify a method to be called on unauthorized access.
  # This is necessary in order to prevent a redirect loop which happens
  # because, by default, user gets redirected to Dashboard. If user
  # doesn't have access to Dashboard, he'll end up in a redirect loop.
  # Method provided here should be defined in application_controller.rb.
  # config.on_unauthorized_access = :access_denied

  # == Current User
  #
  # Active Admin will associate actions with the current
  # user performing them.
  #
  # This setting changes the method which Active Admin calls
  # (within the application controller) to return the currently logged in user.
  config.current_user_method = :current_admin_user

  # == Logging Out
  #
  # Active Admin displays a logout link on each screen. These
  # settings configure the location and method used for the link.
  #
  # This setting changes the path where the link points to. If it's
  # a string, the strings is used as the path. If it's a Symbol, we
  # will call the method to return the path.
  #
  # Default:
  config.logout_link_path = :destroy_admin_user_session_path

  # This setting changes the http method used when rendering the
  # link. For example :get, :delete, :put, etc..
  #
  # Default:
  # config.logout_link_method = :get

  # == Root
  #
  # Set the action to call for the root path. You can set different
  # roots for each namespace.
  #
  # Default:
  # config.root_to = 'dashboard#index'

  # == Admin Comments
  #
  # This allows your users to comment on any resource registered with Active Admin.
  #
  # You can completely disable comments:
  # config.comments = false
  #
  # You can change the name under which comments are registered:
  # config.comments_registration_name = 'AdminComment'
  #
  # You can change the order for the comments and you can change the column
  # to be used for ordering:
  # config.comments_order = 'created_at ASC'
  #
  # You can disable the menu item for the comments index page:
  # config.comments_menu = false
  #
  # You can customize the comment menu:
  # config.comments_menu = { parent: 'Admin', priority: 1 }

  # == Batch Actions
  #
  # Enable and disable Batch Actions
  #
  config.batch_actions = true

  # == Controller Filters
  #
  # You can add before, after and around filters to all of your
  # Active Admin resources and pages from here.
  #
  # config.before_action :do_something_awesome

  # == Localize Date/Time Format
  #
  # Set the localize format to display dates and times.
  # To understand how to localize your app with I18n, read more at
  # https://github.com/svenfuchs/i18n/blob/master/lib%2Fi18n%2Fbackend%2Fbase.rb#L52
  #
  config.localize_format = :long

  # == Setting a Favicon
  #
  # config.favicon = 'favicon.ico'

  # == Meta Tags
  #
  # Add additional meta tags to the head element of active admin pages.
  #
  # Add tags to all pages logged in users see:
  #   config.meta_tags = { author: 'My Company' }

  # By default, sign up/sign in/recover password pages are excluded
  # from showing up in search engine results by adding a robots meta
  # tag. You can reset the hash of meta tags included in logged out
  # pages:
  #   config.meta_tags_for_logged_out_pages = {}

  # == Removing Breadcrumbs
  #
  # Breadcrumbs are enabled by default. You can customize them for individual
  # resources or you can disable them globally from here.
  #
  # config.breadcrumb = false

  # == Create Another Checkbox
  #
  # Create another checkbox is disabled by default. You can customize it for individual
  # resources or you can enable them globally from here.
  #
  # config.create_another = true

  # == Register Stylesheets & Javascripts
  #
  # We recommend using the built in Active Admin layout and loading
  # up your own stylesheets / javascripts to customize the look
  # and feel.
  #
  # To load a stylesheet:
  #   config.register_stylesheet 'my_stylesheet.css'
  #
  # You can provide an options hash for more control, which is passed along to stylesheet_link_tag():
  #   config.register_stylesheet 'my_print_stylesheet.css', media: :print
  #
  # To load a javascript file:
  #   config.register_javascript 'my_javascript.js'

  # == CSV options
  #
  # Set the CSV builder separator
  # config.csv_options = { col_sep: ';' }
  #
  # Force the use of quotes
  # config.csv_options = { force_quotes: true }

  # == Menu System
  #
  # You can add a navigation menu to be used in your application, or configure a provided menu
  #
  # To change the default utility navigation to show a link to your website & a logout btn
  #
  #   config.namespace :admin do |admin|
  #     admin.build_menu :utility_navigation do |menu|
  #       menu.add label: "My Great Website", url: "http://www.mygreatwebsite.com", html_options: { target: :blank }
  #       admin.add_logout_button_to_menu menu
  #     end
  #   end
  #
  # If you wanted to add a static menu item to the default menu provided:
  #
  #   config.namespace :admin do |admin|
  #     admin.build_menu :default do |menu|
  #       menu.add label: "My Great Website", url: "http://www.mygreatwebsite.com", html_options: { target: :blank }
  #     end
  #   end

  # == Download Links
  #
  # You can disable download links on resource listing pages,
  # or customize the formats shown per namespace/globally
  #
  # To disable/customize for the :admin namespace:
  #
  #   config.namespace :admin do |admin|
  #
  #     # Disable the links entirely
  #     admin.download_links = false
  #
  #     # Only show XML & PDF options
  #     admin.download_links = [:xml, :pdf]
  #
  #     # Enable/disable the links based on block
  #     #   (for example, with cancan)
  #     admin.download_links = proc { can?(:view_download_links) }
  #
  #   end

  # == Pagination
  #
  # Pagination is enabled by default for all resources.
  # You can control the default per page count for all resources here.
  #
  # config.default_per_page = 30
  #
  # You can control the max per page count too.
  #
  # config.max_per_page = 10_000

  # == Filters
  #
  # By default the index screen includes a "Filters" sidebar on the right
  # hand side with a filter for each attribute of the registered model.
  # You can enable or disable them for all resources here.
  #
  # config.filters = true
  #
  # By default the filters include associations in a select, which means
  # that every record will be loaded for each association.
  # You can enabled or disable the inclusion
  # of those filters by default here.
  #
  # config.include_default_association_filters = true

  # == Footer
  #
  # By default, the footer shows the current Active Admin version. You can
  # override the content of the footer here.
  #
  config.footer = "We are the photography"

  # == Sorting
  #
  # By default ActiveAdmin::OrderClause is used for sorting logic
  # You can inherit it with own class and inject it for all resources
  #
  # config.order_clause = MyOrderClause

end
