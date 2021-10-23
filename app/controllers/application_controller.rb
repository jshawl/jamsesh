class ApplicationController < ActionController::Base
  include ApplicationHelper
  def index
    if session[:auth]
      @spotify = Spotify::Session.new(session[:auth])
    end
  end

  def spotify_auth_callback
    session[:auth] = request.env['omniauth.auth']
    redirect_to root_path
  end
end
