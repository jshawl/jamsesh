module ApplicationHelper
  def current_user
    @session = Spotify::Session.new(session[:auth])
    return nil if @session.expired?
    @session
  end
end
