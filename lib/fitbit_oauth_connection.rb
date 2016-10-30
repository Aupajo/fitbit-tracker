class FitbitOauthConnection
  attr_reader :config

  def initialize(config: self.class.config)
    @config = config
  end

  def authorization_uri(host:)
    uri = Addressable::URI.parse(config.fetch(:authorization_uri))

    uri.query_values = {
      client_id: config.fetch(:client_id),
      scope: config.fetch(:scopes).join(' '),
      redirect_uri: routes.fitbit_oauth_connections_url(host: host),
      response_type: 'code'
    }

    uri.to_s
  end

  def authorization_request(**args)
    Fitbit::AuthorizationRequest.new(config: config, **args)
  end

  def self.config
    Rails.application.config.fitbit_oauth
  end

  private

  def routes
    Rails.application.routes.url_helpers
  end
end
