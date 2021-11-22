class ApplicationController < ActionController::Base
  include ApplicationHelper
  def index
    if session[:current_user_id]
      @spotify = Spotify::Session.new(session[:current_user_id])
    end
  end

  def spotify_auth_callback
    auth = request.env['omniauth.auth']
    email = auth["info"]["email"]
    @user = if User.exists? email: email
      User.find_by_email(email)
    else
      User.create!(
        name: auth["info"]["name"],
        email: email,
        image: auth["info"]["image"],
        access_token: auth['credentials']['token'],
        refresh_token: auth['credentials']['refresh_token'],
        token_expires_at: auth['credentials']['expires_at'],
      )
    end
    session[:current_user_id] = @user.id
    redirect_to root_path
  end

  def logout
    session.clear
    redirect_to root_path
  end
end
