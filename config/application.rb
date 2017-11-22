require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Mmo
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.cache_store = :redis_store, 'redis://localhost:6379/0', { namespace: "#{Rails.env}:cache" }
    #'redis://localhost:6379/0/cache'
    config.active_job.queue_adapter = :sidekiq

     #config.action_cable.disable_request_forgery_protection = true
     #config.action_cable.mount_path = '/cable'
     #config.action_cable.url = "ws://localhost"
    #config.action_cable.allowed_request_origins = ['http://oomovers.moversnetwork.ca:8091', %r{http://*.moversnetwork.ca:8091}]
    config.middleware.use PDFKit::Middleware, :print_media_type => true

    config.time_zone = 'Pacific Time (US & Canada)'
  end
end
