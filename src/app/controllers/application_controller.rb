class ApplicationController < ActionController::Base

  helper_method :admin?
  before_action :init_session
  
  def admin?
    current_user and ['fabrice.david@epfl.ch'].include?(current_user.email)
  end
  
  def init_session

    session[:d_settings] ||= {:free_text => ''}
  end



end
