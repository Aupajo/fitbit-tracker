module Fitbit
  class AuthorizationRequest
    attr_reader :authorization_code, :config

    def initialize(config:, authorization_code:, local_host:, local_protocol:)
      @config = config
      @authorization_code = authorization_code
      @local_host = local_host
      @local_protocol = local_protocol
    end

    def response
      uri = Addressable::URI.parse(config.fetch(:refresh_token_uri))
      uri.query_values = {
        code: authorization_code,
        redirect_uri: redirect_uri,
        grant_type: 'authorization_code'
      }

      requires_ssl = uri.normalized_scheme == 'https'

      decoded_authorization_token = config.slice(:client_id, :client_secret).values.join(":")
      encoded_authorization_token = Base64.encode64(decoded_authorization_token).strip

      raw_response = Net::HTTP.start(uri.host, uri.port, use_ssl: requires_ssl) do |http|
        request = Net::HTTP::Post.new(uri)
        request['Authorization'] = "Basic #{encoded_authorization_token}"

        http.request(request)
      end

      AuthorizationResponse.new(raw_response)
    end

    private

    def redirect_uri
      Rails.application.routes.url_helpers.fitbit_oauth_connections_url(host: @local_host, protocol: @local_protocol)
    end
  end
end
