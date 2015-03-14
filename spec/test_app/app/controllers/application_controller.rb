class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user

  def current_user
    nil
  end
end
