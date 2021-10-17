require 'net/http'
module Spotify
  class Session
    def initialize auth_hash
      @auth_hash = auth_hash
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
      }).body)
      {
        artist_name: current["item"]["artists"].map{|art| art["name"]}.join(", "),
        song_title: current["item"]["name"],
        duration_ms: current["item"]["duration_ms"],
        progress_ms: current["progress_ms"],
        image: current["item"]["album"]["images"][1]["url"],
        original: current
      }
    end
  end
end