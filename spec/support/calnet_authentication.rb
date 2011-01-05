module CalNetAuthentication
  def login(user)
    controller.class.skip_before_filter CASClient::Frameworks::Rails::Filter
    controller.stub(:current_user).and_return(user)
  end

  def logout(user)
    logout
  end

  # Example usage in controller spec file:
  # should_require_login :new => :get, :edit => :get, :update => :put, :destroy => :delete
  def should_require_login(*args)
    args = Hash[*args]
    args.each do |action, verb|
      should "Require login for '#{action}' action" do
        send(verb, action)
        assert_redirected_to(login_url)
      end
    end
  end

end
