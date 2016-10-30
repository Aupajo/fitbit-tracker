module Fitbit
  class AuthorizedClient
    attr_reader :user_id, :access_token, :refresh_token

    def initialize(user_id:, access_token:, refresh_token:)
      @user_id = user_id
      @access_token = access_token
      @refresh_token = refresh_token
    end

    def profile
      uri = Addressable::URI.parse("https://api.fitbit.com/1/user/#{user_id}/profile.json")

      requires_ssl = uri.normalized_scheme == 'https'

      Net::HTTP.start(uri.host, uri.port, use_ssl: requires_ssl) do |http|
        request = Net::HTTP::Get.new(uri)
        request['Authorization'] = "Bearer #{access_token}"

        http.request(request)
      end
    end
  end
end
