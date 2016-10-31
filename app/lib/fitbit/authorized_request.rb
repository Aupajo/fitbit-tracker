module Fitbit
  class AuthorizedRequest
    attr_reader :client, :uri, :params

    def initialize(client, uri, **params)
      @client = client
      @uri = Addressable::URI.parse(uri)
      @params = params
    end

    def ssl?
      uri.normalized_scheme == 'https'
    end

    def response
      raw_response = Net::HTTP.start(uri.host, uri.port, use_ssl: ssl?) do |http|
        request = Net::HTTP::Get.new(uri)
        request['Authorization'] = "Bearer #{client.access_token}"

        http.request(request)
      end

      if raw_response.code.to_i == 200
        raw_response
      else
        fail "Don't know how to handle #{raw_response.code} request with body #{raw_response.body}"
      end
    end

    def response_data
      JSON.parse(response.body, symbolize_names: true)
    end
  end
end
