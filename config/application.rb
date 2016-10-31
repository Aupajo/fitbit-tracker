require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module FitbitTracker
  class Application < Rails::Application
    config.canonical_host = ENV.fetch('CANONICAL_HOST')

    config.fitbit_oauth = {
      client_id: ENV['FITBIT_OAUTH_CLIENT_ID'],
      client_secret: ENV['FITBIT_OAUTH_CLIENT_SECRET'],
      authorization_uri: ENV['FITBIT_OAUTH_AUTHORIZATION_URI'],
      refresh_token_uri: ENV['FITBIT_OAUTH_REFRESH_TOKEN_URI'],
      scopes: %w( profile social )
    }
  end
end
