module URI
  def self.encode(a,b)
    a
  end
end

module Api

  class ApiController < ApplicationController
    skip_forgery_protection

    def current
      @spotify = Spotify::Session.new(session[:current_user_id])
      cur = @spotify.get_current(current_user)
      render json: cur
    end
    def control
      @spotify = Spotify::Session.new(session[:current_user_id])
      params["is_playing"] == "false" ? @spotify.play : @spotify.pause
      head 200
    end
    def lyrics
      Genius.access_token = Rails.application.credentials.genius_api_token
      results = Genius::Song.search(params[:query]).map do |result|
        {
          id: result.id,
          full_title: result.resource["full_title"]
        }
      end
      render json: results
    end
    def tabs
      res = HTTParty.get("https://www.ultimate-guitar.com/search.php?search_type=title&value=#{params[:q]}")
      actual_url = res.body.match(/https:\/\/tabs.ultimate-guitar.com\/tab\/([^&]+)/)[0]
      render json: {url: actual_url}
    end
  end

end