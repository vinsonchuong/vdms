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
        it 'routes GET /people/staff to Staff#index' do
          {:get => '/people/staff'}.should route_to(:controller => 'staff', :action => 'index')
        end
      end

      context 'Add Staff' do
        it 'routes GET /people/staff/new to Staff#new' do
          {:get => '/people/staff/new'}.should route_to(:controller => 'staff', :action => 'new')
        end

        it 'routes POST /people/staff to Staff#create' do
          {:post => '/people/staff'}.should route_to(:controller => 'staff', :action => 'create')
        end
      end

      context 'Import Staff' do
        it 'routes GET /people/staff/upload to Staff#upload' do
          {:get => '/people/staff/upload'}.should route_to(:controller => 'staff', :action => 'upload')
        end

        it 'routes POST /people/staff/import to Staff#import' do
          {:post => '/people/staff/import'}.should route_to(:controller => 'staff', :action => 'import')
        end
      end

      context 'Update Staff' do
        it 'routes GET /people/staff/1/edit to Staff#edit' do
          {:get => '/people/staff/1/edit'}.should route_to(:controller => 'staff', :action => 'edit', :id => '1')
        end

        it 'routes PUT /people/staff/1 to Staff#update' do
          {:put => '/people/staff/1'}.should route_to(:controller => 'staff', :action => 'update', :id => '1')
        end
      end

      context 'Remove Staff' do
        it 'routes GET /people/staff/1/delete to Staff#delete' do
          {:get => '/people/staff/1/delete'}.should route_to(:controller => 'staff', :action => 'delete', :id => '1')
        end

        it 'routes DELETE /people/staff/1 to Staff#destroy' do
          {:delete => '/people/staff/1'}.should route_to(:controller => 'staff', :action => 'destroy', :id => '1')
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
        it 'routes GET /people/faculty to Faculty#index' do
          {:get => '/people/faculty'}.should route_to(:controller => 'faculty', :action => 'index')
        end
      end

      context 'Add Faculty' do
        it 'routes GET /people/faculty/new to Faculty#new' do
          {:get => '/people/faculty/new'}.should route_to(:controller => 'faculty', :action => 'new')
        end

        it 'routes POST /people/faculty to Faculty#create' do
          {:post => '/people/faculty'}.should route_to(:controller => 'faculty', :action => 'create')
        end
      end

      context 'Import Faculty' do
        it 'routes GET /people/faculty/upload to Faculty#upload' do
          {:get => '/people/faculty/upload'}.should route_to(:controller => 'faculty', :action => 'upload')
        end

        it 'routes POST /people/faculty/import to Faculty#import' do
          {:post => '/people/faculty/import'}.should route_to(:controller => 'faculty', :action => 'import')
        end
      end

      context 'Update Faculty' do
        it 'routes GET /people/faculty/1/edit to Faculty#edit' do
          {:get => '/people/faculty/1/edit'}.should route_to(:controller => 'faculty', :action => 'edit', :id => '1')
        end

        it 'routes PUT /people/faculty/1 to Faculty#update' do
          {:put => '/people/faculty/1'}.should route_to(:controller => 'faculty', :action => 'update', :id => '1')
        end
      end

      context 'Update Faculty Availability' do
        it 'routes GET /people/faculty/1/schedule to Faculty#schedule' do
          {:get => '/people/faculty/1/schedule'}.should route_to(:controller => 'faculty', :action => 'schedule', :id => '1')
        end
      end

      context 'Update Faculty Admit Rankings' do
        it 'routes GET /people/faculty/1/rank_admits to Faculty#rank_admits' do
          {:get => '/people/faculty/1/rank_admits'}.should route_to(:controller => 'faculty', :action => 'rank_admits', :id => '1')
        end

        it 'routes GET /people/faculty/1/select_admits to Faculty#admits' do
          {:get => '/people/faculty/1/select_admits'}.should route_to(:controller => 'faculty', :action => 'select_admits', :id => '1')
        end
      end

      context 'Remove Faculty' do
        it 'routes GET /people/faculty/1/delete to Faculty#delete' do
          {:get => '/people/faculty/1/delete'}.should route_to(:controller => 'faculty', :action => 'delete', :id => '1')
        end

        it 'routes DELETE /people/faculty/1 to Faculty#destroy' do
          {:delete => '/people/faculty/1'}.should route_to(:controller => 'faculty', :action => 'destroy', :id => '1')
        end
      end
      
      context 'Update Faculty Admit Rankings' do
        it 'routes GET /people/faculty/1/rank_admits to Faculty#rank_admits' do
          {:get => '/people/faculty/1/rank_admits'}.should route_to(:controller => 'faculty', :action => 'rank_admits', :id => '1')
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

        it 'routes GET /people/admits/1/select_faculty to Admits#select_faculty' do
          {:get => '/people/admits/1/select_faculty'}.should route_to(:controller => 'admits', :action => 'select_faculty', :id => '1')
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
    end
    context 'Completed Schedules' do
      it 'can view meetings for a faculty member' do
        {:get => '/people/faculty/1/meetings'}.should route_to(:controller => 'meetings', :action => 'index', :faculty_id => '1')
      end
      it 'can view meetings for an admit' do
        {:get => '/people/admits/1/meetings'}.should route_to(:controller => 'meetings', :action => 'index', :admit_id => '1')
      end
      it 'can view the master schedule' do
        {:get => '/meetings/master'}.should route_to(:controller => 'meetings', :action => 'master')
      end
    end
  end
end
