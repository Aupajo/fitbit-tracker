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
      client = auth_response.authorized_client
      @user_details = JSON.parse(client.profile.body, symbolize_names: true).fetch(:user)
    else
      @errors = auth_response.errors
      render :error
    end
  end
end
