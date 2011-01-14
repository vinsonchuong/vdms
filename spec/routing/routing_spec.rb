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

  context 'Staff' do
    context 'Home' do
      it 'routes GET /staff to Staff#home' do
        {:get => '/staff'}.should route_to(:controller => 'staff', :action => 'home')
      end
    end
  end

  context 'Peer Advisor' do
    context 'Home' do
      it 'routes GET /peer_advisor to PeerAdvisor#home' do
        {:get => '/peer_advisor'}.should route_to(:controller => 'peer_advisor', :action => 'home')
      end
    end
  end

  context 'Faculty' do
    context 'Home' do
      it 'routes GET /faculty to Faculty#home' do
        {:get => '/faculty'}.should route_to(:controller => 'faculty', :action => 'home')
      end
    end
  end
end
