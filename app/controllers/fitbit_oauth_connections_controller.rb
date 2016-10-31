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

      @user_details = client.profile
      @friends = client.friends

      @authenticated_user = AuthenticatedUser.new(
        access_token: client.access_token,
        refresh_token: client.refresh_token,
        watching: @friends.map { |friend| friend[:encodedId] }
      )

      @fitbit_user = FitbitUser.new(
        remote_id: @user_details[:encodedId],
        display_name: @user_details[:displayName],
        full_name: @user_details[:fullName],
        timezone: @user_details[:timezone],
        avatars: @user_details.slice(:avatar, :avatar150)
      )
    else
      @errors = auth_response.errors
      render :error
    end
  end
end
