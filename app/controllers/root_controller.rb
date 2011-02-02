class RootController < ApplicationController
  skip_before_filter CASClient::Frameworks::Rails::Filter, :only => :home

  # GET /
  def home
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
