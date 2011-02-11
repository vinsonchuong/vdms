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

  context 'People' do
    context 'Staff' do
      context 'View Staff' do
        it 'routes GET /people/staffs to Staffs#index' do
          {:get => '/people/staffs'}.should route_to(:controller => 'staffs', :action => 'index')
        end
      end

      context 'Add Staff' do
        it 'routes GET /people/staffs/new to Staffs#new' do
          {:get => '/people/staffs/new'}.should route_to(:controller => 'staffs', :action => 'new')
        end

        it 'routes POST /people/staffs to Staffs#create' do
          {:post => '/people/staffs'}.should route_to(:controller => 'staffs', :action => 'create')
        end
      end

      context 'Import Staff' do
        it 'routes GET /people/staffs/upload to Staffs#upload' do
          {:get => '/people/staffs/upload'}.should route_to(:controller => 'staffs', :action => 'upload')
        end

        it 'routes POST /people/staffs/import to Staffs#import' do
          {:post => '/people/staffs/import'}.should route_to(:controller => 'staffs', :action => 'import')
        end
      end

      context 'Update Staff' do
        it 'routes GET /people/staffs/1/edit to Staffs#edit' do
          {:get => '/people/staffs/1/edit'}.should route_to(:controller => 'staffs', :action => 'edit', :id => '1')
        end

        it 'routes PUT /people/staffs/1 to Staffs#update' do
          {:put => '/people/staffs/1'}.should route_to(:controller => 'staffs', :action => 'update', :id => '1')
        end
      end

      context 'Remove Staff' do
        it 'routes GET /people/staffs/1/delete to Staffs#delete' do
          {:get => '/people/staffs/1/delete'}.should route_to(:controller => 'staffs', :action => 'delete', :id => '1')
        end

        it 'routes DELETE /people/staffs/1 to Staffs#destroy' do
          {:delete => '/people/staffs/1'}.should route_to(:controller => 'staffs', :action => 'destroy', :id => '1')
        end
      end
    end

    context 'Peer Advisors' do
      context 'View Peer Advisors' do
        it 'routes GET /people/peer_advisors to PeerAdvisors#index' do
          {:get => '/people/peer_advisors'}.should route_to(:controller => 'peer_advisors', :action => 'index')
        end
      end

      context 'Add Peer Advisors' do
        it 'routes GET /people/peer_advisors/new to PeerAdvisors#new' do
          {:get => '/people/peer_advisors/new'}.should route_to(:controller => 'peer_advisors', :action => 'new')
        end

        it 'routes POST /people/peer_advisors to PeerAdvisors#create' do
          {:post => '/people/peer_advisors'}.should route_to(:controller => 'peer_advisors', :action => 'create')
        end
      end

      context 'Import Peer Advisors' do
        it 'routes GET /people/peer_advisors/upload to PeerAdvisors#upload' do
          {:get => '/people/peer_advisors/upload'}.should route_to(:controller => 'peer_advisors', :action => 'upload')
        end

        it 'routes POST /people/peer_advisors/import to PeerAdvisors#import' do
          {:post => '/people/peer_advisors/import'}.should route_to(:controller => 'peer_advisors', :action => 'import')
        end
      end

      context 'Update Peer Advisors' do
        it 'routes GET /people/peer_advisors/1/edit to PeerAdvisors#edit' do
          {:get => '/people/peer_advisors/1/edit'}.should route_to(:controller => 'peer_advisors', :action => 'edit', :id => '1')
        end

        it 'routes PUT /people/peer_advisors/1 to PeerAdvisors#update' do
          {:put => '/people/peer_advisors/1'}.should route_to(:controller => 'peer_advisors', :action => 'update', :id => '1')
        end
      end

      context 'Remove Peer Advisors' do
        it 'routes GET /people/peer_advisors/1/delete to PeerAdvisors#delete' do
          {:get => '/people/peer_advisors/1/delete'}.should route_to(:controller => 'peer_advisors', :action => 'delete', :id => '1')
        end

        it 'routes DELETE /people/peer_advisors/1 to PeerAdvisors#destroy' do
          {:delete => '/people/peer_advisors/1'}.should route_to(:controller => 'peer_advisors', :action => 'destroy', :id => '1')
        end
      end
    end

    context 'Faculty' do
      context 'View Faculty' do
        it 'routes GET /people/faculties to Faculties#index' do
          {:get => '/people/faculties'}.should route_to(:controller => 'faculties', :action => 'index')
        end
      end

      context 'Add Faculty' do
        it 'routes GET /people/faculties/new to Faculties#new' do
          {:get => '/people/faculties/new'}.should route_to(:controller => 'faculties', :action => 'new')
        end

        it 'routes POST /people/faculties to Faculties#create' do
          {:post => '/people/faculties'}.should route_to(:controller => 'faculties', :action => 'create')
        end
      end

      context 'Import Faculty' do
        it 'routes GET /people/faculties/upload to Faculties#upload' do
          {:get => '/people/faculties/upload'}.should route_to(:controller => 'faculties', :action => 'upload')
        end

        it 'routes POST /people/faculties/import to Faculties#import' do
          {:post => '/people/faculties/import'}.should route_to(:controller => 'faculties', :action => 'import')
        end
      end

      context 'Update Faculty' do
        it 'routes GET /people/faculties/1/edit to Faculties#edit' do
          {:get => '/people/faculties/1/edit'}.should route_to(:controller => 'faculties', :action => 'edit', :id => '1')
        end

        it 'routes PUT /people/faculties/1 to Faculties#update' do
          {:put => '/people/faculties/1'}.should route_to(:controller => 'faculties', :action => 'update', :id => '1')
        end
      end

      context 'Update Faculty Schedule' do
        it 'routes GET /people/faculties/1/schedule to Faculties#schedule' do
          {:get => '/people/faculties/1/schedule'}.should route_to(:controller => 'faculties', :action => 'schedule', :id => '1')
        end
      end

      context 'Remove Faculty' do
        it 'routes GET /people/faculties/1/delete to Faculties#delete' do
          {:get => '/people/faculties/1/delete'}.should route_to(:controller => 'faculties', :action => 'delete', :id => '1')
        end

        it 'routes DELETE /people/faculties/1 to Faculties#destroy' do
          {:delete => '/people/faculties/1'}.should route_to(:controller => 'faculties', :action => 'destroy', :id => '1')
        end
      end
      
      context 'Update Faculty Admit Rankings' do
        it 'routes GET /people/faculties/1/rank_admits to Faculties#rank_admits' do
          {:get => '/people/faculties/1/rank_admits'}.should route_to(:controller => 'faculties', :action => 'rank_admits', :id => '1')
        end
      end
    end

    context 'Admits' do
      context 'View Admits' do
        it 'routes GET /people/admits to Admits#index' do
          {:get => '/people/admits'}.should route_to(:controller => 'admits', :action => 'index')
        end
      end

      context 'Add Admits' do
        it 'routes GET /people/admits/new to Admits#new' do
          {:get => '/people/admits/new'}.should route_to(:controller => 'admits', :action => 'new')
        end

        it 'routes POST /people/admits to Admits#create' do
          {:post => '/people/admits'}.should route_to(:controller => 'admits', :action => 'create')
        end
      end

      context 'Import Admits' do
        it 'routes GET /people/admits/upload to Admits#upload' do
          {:get => '/people/admits/upload'}.should route_to(:controller => 'admits', :action => 'upload')
        end

        it 'routes POST /people/admits/import to Admits#import' do
          {:post => '/people/admits/import'}.should route_to(:controller => 'admits', :action => 'import')
        end
      end

      context 'Update Admits' do
        it 'routes GET /people/admits/1/edit to Admits#edit' do
          {:get => '/people/admits/1/edit'}.should route_to(:controller => 'admits', :action => 'edit', :id => '1')
        end

        it 'routes PUT /people/admits/1 to Admits#update' do
          {:put => '/people/admits/1'}.should route_to(:controller => 'admits', :action => 'update', :id => '1')
        end
      end

      context 'Update Admit Availability' do
        it 'routes GET /people/admits/1/schedule to Admits#schedule' do
          {:get => '/people/admits/1/schedule'}.should route_to(:controller => 'admits', :action => 'schedule', :id => '1')
        end
      end

      context 'Update Admit Faculty Rankings' do
        it 'routes GET /people/admits/1/rank_faculty to Admits#rank_faculty' do
          {:get => '/people/admits/1/rank_faculty'}.should route_to(:controller => 'admits', :action => 'rank_faculty', :id => '1')
        end
      end

      context 'Remove Admits' do
        it 'routes GET /people/admits/1/delete to Admits#delete' do
          {:get => '/people/admits/1/delete'}.should route_to(:controller => 'admits', :action => 'delete', :id => '1')
        end

        it 'routes DELETE /people/admits/1 to Admits#destroy' do
          {:delete => '/people/admits/1'}.should route_to(:controller => 'admits', :action => 'destroy', :id => '1')
        end
      end
      
      context 'Filter Admits' do
        it 'routes GET /people/PEOPLE/admits/filter to Admits#filter' do
          {:get => '/people/admits/filter'}.should route_to(:controller => 'admits', :action => 'filter')
        end
      end
    end
  end
end
