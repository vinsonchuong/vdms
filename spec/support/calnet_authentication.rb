module CalNetAuthentication
  def login(user)
    controller.class.skip_before_filter CASClient::Frameworks::Rails::Filter
    controller.stub(:current_user).and_return(user)
  end

  def logout(user)
    logout
  end

  # example usage in controller spec file
  # should_require_login :edit, :new, :destroy
  def should_require_login(*actions)
    actions.each do |action|
      should "Require login for '#{action}' action" do
        get action
        assert_redirected_to(login_url)
      end
    end
  end

end
