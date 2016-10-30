module Fitbit
  class AuthorizedClient
    attr_reader :user_id, :access_token, :refresh_token

    def initialize(user_id:, access_token:, refresh_token:)
      @user_id = user_id
      @access_token = access_token
      @refresh_token = refresh_token
    end

    def profile
      request("https://api.fitbit.com/1/user/#{user_id}/profile.json")
        .response_data
        .fetch(:user)
    end

    def friends
      friends_leaderboard.map { |entry| entry[:user] }
    end

    def friends_leaderboard
      request("https://api.fitbit.com/1/user/#{user_id}/friends/leaderboard.json")
        .response_data
        .fetch(:friends)
    end

    def request(uri, **params)
      AuthorizedRequest.new(self, uri, params)
    end
  end
end
