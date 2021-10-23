require 'net/http'
require "base64"
module Spotify
  class Session
    def initialize auth_hash
      @auth_hash = auth_hash
      # if !expired?
      #   @auth_hash["credentials"]["token"] = refresh_access_token
      # end
    end
    def expired?
      @auth_hash["credentials"]["expires_at"] < Time.now.to_i
    end
    def basic
      {
        name: @auth_hash["info"]["name"],
        email: @auth_hash["info"]["email"],
        image: @auth_hash["info"]["image"],
        credentials: @auth_hash["credentials"].merge(
          expires_in: @auth_hash["credentials"]["expires_at"] - Time.now.to_i
        ),
      }
    end
    def get_current
        current = JSON.parse(HTTParty.get('https://api.spotify.com/v1/me/player?market=US', headers: {
          Authorization: "Bearer #{@auth_hash['credentials']['token']}"
        }).body || '{}')
        {
          artist_name: current["item"]["artists"].map{|art| art["name"]}.join(", "),
          song_title: current["item"]["name"],
          duration_ms: current["item"]["duration_ms"],
          progress_ms: current["progress_ms"],
          image: current["item"]["album"]["images"][1]["url"],
          # debug: current 
        }
    end

    def refresh_access_token
      Rails.logger.debug "Refreshing Access Token"
      auth = Base64.strict_encode64("#{Rails.application.credentials.spotify_client_id}:#{Rails.application.credentials.spotify_client_secret}")
      response = JSON.parse(HTTParty.post("https://accounts.spotify.com/api/token", 
        headers: {
          Authorization: "Basic #{auth}"
        },
        body: {
          grant_type: 'refresh_token',
          refresh_token: @auth_hash["credentials"]["refresh_token"]
        }
      ).body)
      Rails.logger.debug "Got #{response}"
      response["access_token"]
    end
  end
end