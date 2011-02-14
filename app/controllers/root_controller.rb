class RootController < ApplicationController
  skip_before_filter CASClient::Frameworks::Rails::Filter, :only => :home
  skip_before_filter :get_current_user, :only => :home
  skip_before_filter :verify_new_user, :only => :home
  
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
end
