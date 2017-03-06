class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  #connect to algorithm
  include Connect
  
  before_filter :get_notifications
  
  
  def get_notifications
    if session[:user_id].nil?
      return
    end
    
  
    @notifs = User.find(session[:user_id]).get_notifications
  end
  
end
