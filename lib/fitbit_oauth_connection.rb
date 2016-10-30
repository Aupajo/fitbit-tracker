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

  def authorization_response_from(code:, host:)
    uri = Addressable::URI.parse(config.fetch(:refresh_token_uri))
    uri.query_values = {
      code: code,
      redirect_uri: routes.fitbit_oauth_connections_url(host: host),
      grant_type: 'authorization_code'
    }

    requires_ssl = uri.normalized_scheme == 'https'

    decoded_authorization_token = config.slice(:client_id, :client_secret).values.join(":")
    encoded_authorization_token = Base64.encode64(decoded_authorization_token).strip

    Net::HTTP.start(uri.host, uri.port, use_ssl: requires_ssl) do |http|
      request = Net::HTTP::Post.new(uri)
      request['Authorization'] = "Basic #{encoded_authorization_token}"

      http.request(request)
    end
  end

  def self.config
    Rails.application.config.fitbit_oauth
  end

  private

  def routes
    Rails.application.routes.url_helpers
  end
end
