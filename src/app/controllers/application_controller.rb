class ApplicationController < ActionController::Base

  helper_method :admin?
  before_action :init_session
  
  def admin?
    current_user and ['fabrice.david@epfl.ch'].include?(current_user.email)
  end
  
  def init_session    
    session[:dataset_settings] ||= {:free_text => '', :filters => {}}
    session[:d_settings] ||= {:free_text => '', :filters => {}}
  end



end
