module ApplicationHelper
  def current_user
    return nil unless session[:current_user_id]
    User.find(session[:current_user_id])
  end
end
