module Fitbit
  class AuthorizationResponse
    attr_reader :raw

    def initialize(raw)
      @raw = raw
    end

    def succeeded?
      raw.code.to_i == 200 && errors.empty?
    end

    def user_id
      data.fetch(:user_id)
    end

    def access_token
      data.fetch(:access_token)
    end

    def refresh_token
      data.fetch(:refresh_token)
    end

    def errors
      data.fetch(:errors, [])
    end

    private

    def data
      @data ||= JSON.parse(raw.body, symbolize_names: true)
    end
  end
end
