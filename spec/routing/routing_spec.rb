require 'spec_helper'

describe 'Routes' do
  context 'Home' do
    it 'routes GET / to Root#index' do
      {:get => '/'}.should route_to(:controller => 'root', :action => 'home')
    end
  end

  context 'Sign Out' do
    it 'routes GET /sign_out to Root#sign_out' do
      {:get => '/sign_out'}.should route_to(:controller => 'root', :action => 'sign_out')
    end

    it 'routes DELETE /sign_out to Root#sign_out' do
      {:delete => '/sign_out'}.should route_to(:controller => 'root', :action => 'sign_out')
    end
  end

  context 'Staff Dashboard' do
    it 'routes GET /staff to Root#staff_dashboard' do
      {:get => '/staff'}.should route_to(:controller => 'root', :action => 'staff_dashboard')
    end
  end

  context 'Peer Advisor Dashboard' do
    it 'routes GET /peer_advisor to Root#peer_advisor_dashboard' do
      {:get => '/peer_advisor'}.should route_to(:controller => 'root', :action => 'peer_advisor_dashboard')
    end
  end

  context 'Faculty Dashboard' do
    it 'routes GET /faculty to Root#faculty_dashboard' do
      {:get => '/faculty'}.should route_to(:controller => 'root', :action => 'faculty_dashboard')
    end
  end

  context 'Settings' do
    context 'Update Settings' do
      it 'routes GET /settings/edit do Settings#edit' do
        {:get => '/settings/edit'}.should route_to(:controller => 'settings', :action => 'edit')
      end

      it 'routes PUT /settings to Settings#update' do
        {:put => '/settings'}.should route_to(:controller => 'settings', :action => 'update')
      end
    end
  end
end
