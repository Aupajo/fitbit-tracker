namespace :fitbit do
  task :fetch_readings => :environment do
    config = Rails.application.config.fitbit_oauth

    AuthenticatedUser.find_each do |user|
      # Fetch fresh credentials
      uri = Addressable::URI.parse(config.fetch(:refresh_token_uri))
      uri.query_values = {
        refresh_token: user.refresh_token,
        grant_type: 'refresh_token'
      }

      requires_ssl = uri.normalized_scheme == 'https'

      decoded_authorization_token = config.slice(:client_id, :client_secret).values.join(":")
      encoded_authorization_token = Base64.encode64(decoded_authorization_token).strip

      raw_response = Net::HTTP.start(uri.host, uri.port, use_ssl: requires_ssl) do |http|
        request = Net::HTTP::Post.new(uri)
        request['Authorization'] = "Basic #{encoded_authorization_token}"

        http.request(request)
      end

      if raw_response.code.to_i != 200
        fail "Don't know how to handle #{raw_response.code} response with body #{raw_response.body}"
      else
        data = JSON.parse(raw_response.body, symbolize_names: true)
        credentials = data.slice(:access_token, :refresh_token)
        print "Updating credentials for #{user.fitbit_user.display_name} (#{user.fitbit_user.remote_id})... "
        user.update!(credentials)
        puts "OK"
      end

      puts "Fetching leaderboard for #{user.fitbit_user.display_name} (#{user.fitbit_user.remote_id})... "
      client = Fitbit::AuthorizedClient.new(
        user_id: user.fitbit_user.remote_id,
        access_token: user.access_token,
        refresh_token: user.refresh_token
      )

      client.friends_leaderboard.each do |friend_data|
        user_data = friend_data.fetch(:user)
        remote_id = user_data.fetch(:encodedId)

        print "--> #{user_data.fetch(:displayName)} (#{remote_id})... "

        if !user.watching.include?(remote_id)
          puts "skip"
          next
        end

        fitbit_user = FitbitUser.find_or_create_by!(remote_id: user_data.fetch(:encodedId)) do |friend|
          friend.display_name = user_data.fetch(:displayName)
          friend.full_name = user_data.fetch(:fullName)
          friend.avatars = user_data.slice(:avatar, :avatar150)
          friend.timezone = user_data.fetch(:timezone)
        end

        reading = {
          lifetime_steps: friend_data.dig(:lifetime, :steps),
          monthly_steps: friend_data.dig(:summary, :steps),
          average_steps: friend_data.dig(:average, :steps),
        }

        fitbit_user.readings.create!(reading)

        puts reading.inspect
      end
    end
  end
end
