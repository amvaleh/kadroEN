require_relative 'boot'

require 'rails/all'



# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ReserveKadro
  class Application < Rails::Application
    require Rails.root.join('lib', 'email_tracker', 'rack')
    # Some other stuff
    config.middleware.use EmailTracker::Rack
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.action_dispatch.default_headers = {
      'Access-Control-Allow-Origin' => 'https://www.kadro.co',
      'Access-Control-Request-Method' => %w{GET POST OPTIONS}.join(",")
    }
    config.active_job.queue_adapter = :sidekiq

    config.autoload_paths << Rails.root.join('app', 'forms')
    config.autoload_paths << Rails.root.join('app', 'interactors')
    config.autoload_paths << Rails.root.join('app', 'serializers')

    # config.action_mailer.deliver_later_queue_name = :sidekiq
    Rails.application.config.i18n.default_locale = :en

    config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif)
    config.assets.enabled = true
    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'
    if Rails.env.production?
      config.exceptions_app = self.routes
    end
  end
end
