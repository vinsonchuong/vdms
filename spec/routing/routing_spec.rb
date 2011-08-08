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
    context 'View People' do
      it 'routes GET /people to People#index' do
        {:get => '/people'}.should route_to(:controller => 'people', :action => 'index')
      end
    end

    context 'Remove All People' do
      it 'routes GET /people/delete_all to People#delete_all' do
        {:get => '/people/delete_all'}.should route_to(:controller => 'people', :action => 'delete_all')
      end

      it 'routes DELETE /people/destroy_all to People#destroy_all' do
        {:delete => '/people/destroy_all'}.should route_to(:controller => 'people', :action => 'destroy_all')
      end
    end

    context 'Add People' do
      it 'routes GET /people/new to People#new' do
        {:get => '/people/new'}.should route_to(:controller => 'people', :action => 'new')
      end

      it 'routes POST /people to People#create' do
        {:post => '/people'}.should route_to(:controller => 'people', :action => 'create')
      end
    end

    context 'Import People' do
      it 'routes GET /people/upload to People#upload' do
        {:get => '/people/upload'}.should route_to(:controller => 'people', :action => 'upload')
      end

      it 'routes POST /people/import to People#import' do
        {:post => '/people/import'}.should route_to(:controller => 'people', :action => 'import')
      end
    end

    context 'Update Person' do
      it 'routes GET /people/1/edit to People#edit' do
        {:get => '/people/1/edit'}.should route_to(:controller => 'people', :action => 'edit', :id => '1')
      end

      it 'routes PUT /people/1 to People#update' do
        {:put => '/people/1'}.should route_to(:controller => 'people', :action => 'update', :id => '1')
      end
    end

    context 'Remove Person' do
      it 'routes GET /people/1/delete to Person#delete' do
        {:get => '/people/1/delete'}.should route_to(:controller => 'people', :action => 'delete', :id => '1')
      end

      it 'routes DELETE /people/1 to Person#destroy' do
        {:delete => '/people/1'}.should route_to(:controller => 'people', :action => 'destroy', :id => '1')
      end
    end
  end

  describe 'Events' do
    describe 'Hosts' do
      describe 'Rankings' do
        context 'when adding' do
          it 'routes GET /hosts/1/rankings/add to HostRankings#add' do
            {:get => '/hosts/1/rankings/add'}.should route_to(:controller => 'host_rankings', :action => 'add', :host_id => '1')
          end
        end
        context 'when updating' do
          it 'routes GET /hosts/1/rankings/edit_all to HostRankings#edit_all' do
            {:get => '/hosts/1/rankings/edit_all'}.should route_to(:controller => 'host_rankings', :action => 'edit_all', :host_id => '1')
          end
          it 'routes PUT /hosts/1/rankings/update_all to HostRankings#update_all' do
            {:put => '/hosts/1/rankings/update_all'}.should route_to(:controller => 'host_rankings', :action => 'update_all', :host_id => '1')
          end
        end
      end
      describe 'Availabilities' do
        context 'when updating' do
          it 'routes GET /hosts/1/availabilities/edit_all to HostAvailabilities#edit_all' do
            {:get => '/hosts/1/availabilities/edit_all'}.should route_to(:controller => 'host_availabilities', :action => 'edit_all', :host_id => '1')
          end
          it 'routes PUT /hosts/1/availabilities/update_all to HostAvailabilities#update_all' do
            {:put => '/hosts/1/availabilities/update_all'}.should route_to(:controller => 'host_availabilities', :action => 'update_all', :host_id => '1')
          end
        end
      end
      describe 'Meetings' do
        context 'when viewing' do
          it 'routes GET /hosts/1/meetings to Meetings#index' do
            {:get => '/hosts/1/meetings'}.should route_to(:controller => 'meetings', :action => 'index', :host_id => '1')
          end
        end
        context 'when updating' do
          it 'routes GET /hosts/1/meetings/tweak to Meetings#tweak' do
            {:get => '/hosts/1/meetings/tweak'}.should route_to(:controller => 'meetings', :action => 'tweak', :host_id => '1')
          end
          it 'routes POST /hosts/1/meetings/apply_tweaks to Meetings#apply_tweaks' do
            {:post => '/hosts/1/meetings/apply_tweaks'}.should route_to(:controller => 'meetings', :action => 'apply_tweaks', :host_id => '1')
          end
        end
      end
    end
    describe 'Visitors' do
      describe 'Rankings' do
        context 'when adding' do
          it 'routes GET /visitors/1/rankings/add to VisitorRankings#add' do
            {:get => '/visitors/1/rankings/add'}.should route_to(:controller => 'visitor_rankings', :action => 'add', :visitor_id => '1')
          end
        end
        context 'when updating' do
          it 'routes GET /visitors/1/rankings/edit_all to VisitorRankings#edit_all' do
            {:get => '/visitors/1/rankings/edit_all'}.should route_to(:controller => 'visitor_rankings', :action => 'edit_all', :visitor_id => '1')
          end
          it 'routes PUT /visitors/1/rankings/update_all to VisitorRankings#update_all' do
            {:put => '/visitors/1/rankings/update_all'}.should route_to(:controller => 'visitor_rankings', :action => 'update_all', :visitor_id => '1')
          end
        end
      end
      describe 'Availabilities' do
        context 'when updating' do
          it 'routes GET /visitors/1/availabilities/edit_all to VisitorAvailabilities#edit_all' do
            {:get => '/visitors/1/availabilities/edit_all'}.should route_to(:controller => 'visitor_availabilities', :action => 'edit_all', :visitor_id => '1')
          end
          it 'routes PUT /visitors/1/availabilities/update_all to VisitorAvailabilities#update_all' do
            {:put => '/visitors/1/availabilities/update_all'}.should route_to(:controller => 'visitor_availabilities', :action => 'update_all', :visitor_id => '1')
          end
        end
      end
      describe 'Meetings' do
        context 'when viewing' do
          it 'routes GET /visitors/1/meetings to Meetings#index' do
            {:get => '/visitors/1/meetings'}.should route_to(:controller => 'meetings', :action => 'index', :visitor_id => '1')
          end
        end
      end
    end
  end
end
