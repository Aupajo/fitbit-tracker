class FitbitOauthConnectionsController < ApplicationController
  def new
    connection = FitbitOauthConnection.new
    redirect_to connection.authorization_uri(host: request.host_with_port)
  end

  def confirm
    connection = FitbitOauthConnection.new
    auth = connection.authorization_response_from(code: params.fetch(:code), host: request.host_with_port)

    if auth.code.to_i != 200
      fail auth.body
    end

    auth_details = JSON.parse(auth.body, symbolize_names: true)

    @user_details = JSON.parse(fetch_user_details(auth_details).body, symbolize_names: true).fetch(:user)
  end

  private

  def fetch_user_details(auth_details)
    uri = Addressable::URI.parse("https://api.fitbit.com/1/user/#{auth_details.fetch(:user_id)}/profile.json")

    requires_ssl = uri.normalized_scheme == 'https'

    Net::HTTP.start(uri.host, uri.port, use_ssl: requires_ssl) do |http|
      request = Net::HTTP::Get.new(uri)
      request['Authorization'] = "Bearer #{auth_details.fetch(:access_token)}"

      http.request(request)
    end
  end
end
