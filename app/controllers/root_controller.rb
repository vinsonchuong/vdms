class RootController < ApplicationController
  skip_before_filter CASClient::Frameworks::Rails::Filter

  # GET /
  def home
  end

  # GET /sign_out
  # POST /sign_out
  def sign_out
    CASClient::Frameworks::Rails::Filter.logout(self, home_url)
  end
end
