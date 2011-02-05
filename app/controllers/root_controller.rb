class RootController < ApplicationController
  skip_before_filter CASClient::Frameworks::Rails::Filter, :only => :home
  skip_before_filter :create_new_user_if_no_current_user, :only => [:home, :sign_out]
  
  # GET /
  def home
    render :layout => 'home'
  end

  # GET /sign_out
  # POST /sign_out
  def sign_out
    CASClient::Frameworks::Rails::Filter.logout(self, home_url)
  end

  # GET /staff
  def staff_dashboard
  end

  # GET /peer_advisor
  def peer_advisor_dashboard
  end

  # GET /faculty
  def faculty_dashboard
  end

  def access_denied
  end

end
