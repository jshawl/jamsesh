require 'net/http'
require "base64"
module Spotify
  class Session
    def initialize user_id
      @user = User.find_by(id: user_id)
      # if !expired?
      #   @auth_hash["credentials"]["token"] = refresh_access_token
      # end
    end
    def expired?
      return true if @user.nil?
      @user.token_expires_at < Time.now.to_i
    end
    def basic
      {
        name: @user.name,
        email: @user.email,
        image: @user.image
      }
    end
    def get_current user
        current = JSON.parse(HTTParty.get('https://api.spotify.com/v1/me/player?market=US', headers: {
          Authorization: "Bearer #{user.access_token}"
        }).body || '{}')
        p current
        if current["error"]
          refresh_access_token(user)
          return {}
        end
        return {} if current.empty?
        {
          artist_name: current["item"]["artists"].map{|art| art["name"]}.join(", "),
          song_title: current["item"]["name"],
          duration_ms: current["item"]["duration_ms"],
          progress_ms: current["progress_ms"],
          image: current["item"]["album"]["images"][1]["url"],
          # debug: current 
        }
    end

    def refresh_access_token(user)
      Rails.logger.debug "Refreshing Access Token"
      auth = Base64.strict_encode64("#{Rails.application.credentials.spotify_client_id}:#{Rails.application.credentials.spotify_client_secret}")
      response = JSON.parse(HTTParty.post("https://accounts.spotify.com/api/token", 
        headers: {
          Authorization: "Basic #{auth}"
        },
        body: {
          grant_type: 'refresh_token',
          refresh_token: user.refresh_token
        }
      ).body)
      Rails.logger.debug "Got #{response}"
      user.update(access_token: response["access_token"])
      response["access_token"]
    end
  end
end