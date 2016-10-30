class FitbitOauthConnectionsController < ApplicationController
  def new
    connection = FitbitOauthConnection.new
    redirect_to connection.authorization_uri(host: request.host_with_port)
  end

  def confirm
    connection = FitbitOauthConnection.new

    auth_request = connection.authorization_request(
      authorization_code: params.fetch(:code),
      local_host: request.host_with_port
    )

    auth_response = auth_request.response

    if auth_response.succeeded?
      @user_details = JSON.parse(fetch_user_details(auth_response).body, symbolize_names: true).fetch(:user)
    else
      @errors = auth_response.errors
      render :error
    end
  end

  private

  def fetch_user_details(auth)
    uri = Addressable::URI.parse("https://api.fitbit.com/1/user/#{auth.user_id}/profile.json")

    requires_ssl = uri.normalized_scheme == 'https'

    Net::HTTP.start(uri.host, uri.port, use_ssl: requires_ssl) do |http|
      request = Net::HTTP::Get.new(uri)
      request['Authorization'] = "Bearer #{auth.access_token}"

      http.request(request)
    end
  end
end
