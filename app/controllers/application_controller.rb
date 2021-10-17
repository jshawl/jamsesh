class ApplicationController < ActionController::Base
  def index
    @spotify = Spotify::Session.new(session[:auth])
    @current = @spotify.get_current
  end

  def spotify_auth_callback
    session[:auth] = request.env['omniauth.auth']
    redirect_to root_path
  end
end
