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
      @user_details = auth_response.authorized_client.profile
    else
      @errors = auth_response.errors
      render :error
    end
  end
end
