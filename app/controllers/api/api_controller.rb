module URI
  def self.encode(a,b)
    a
  end
end

module Api

  class ApiController < ApplicationController
    def current
      @spotify = Spotify::Session.new(session[:auth])
      cur = @spotify.get_current(current_user)
      render json: cur.merge(lyrics_id: lyrics(cur))
    end
    def lyrics(cur)
      return nil if cur.empty?
      Genius.access_token = Rails.application.credentials.genius_api_token
      Genius::Song.search(cur[:artist_name] + cur[:song_title])[0].id
    end
    def tabs
      res = HTTParty.get("https://www.ultimate-guitar.com/search.php?search_type=title&value=#{params[:q]}")
      actual_url = res.body.match(/https:\/\/tabs.ultimate-guitar.com\/tab\/([^&]+)/)[0]
      render json: {url: actual_url}
    end
  end

end