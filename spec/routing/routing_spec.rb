require 'spec_helper'

describe 'Routes' do
  it 'routes GET / to Events#index' do
    {:get => '/'}.should route_to(:controller => 'events', :action => 'index')
  end

  context 'People' do
    context 'when viewing' do
      it 'routes GET /people to People#index' do
        {:get => '/people'}.should route_to(:controller => 'people', :action => 'index')
      end
      it 'routes GET /people/1 to People#show' do
        {:get => '/people/1'}.should route_to(:controller => 'people', :action => 'show', :id => '1')
      end
    end
    context 'when adding' do
      context 'via form' do
        it 'routes GET /people/new to People#new' do
          {:get => '/people/new'}.should route_to(:controller => 'people', :action => 'new')
        end
        it 'routes POST /people to People#create' do
          {:post => '/people'}.should route_to(:controller => 'people', :action => 'create')
        end
      end
      context 'via import' do
        it 'routes GET /people/upload to People#upload' do
          {:get => '/people/upload'}.should route_to(:controller => 'people', :action => 'upload')
        end
        it 'routes POST /people/import to People#import' do
          {:post => '/people/import'}.should route_to(:controller => 'people', :action => 'import')
        end
      end
    end
    context 'when updating' do
      it 'routes GET /people/1/edit to People#edit' do
        {:get => '/people/1/edit'}.should route_to(:controller => 'people', :action => 'edit', :id => '1')
      end
      it 'routes PUT /people/1 to People#update' do
        {:put => '/people/1'}.should route_to(:controller => 'people', :action => 'update', :id => '1')
      end
    end
    context 'when removing' do
      it 'routes GET /people/1/delete to People#delete' do
        {:get => '/people/1/delete'}.should route_to(:controller => 'people', :action => 'delete', :id => '1')
      end
      it 'routes DELETE /people/1 to People#destroy' do
        {:delete => '/people/1'}.should route_to(:controller => 'people', :action => 'destroy', :id => '1')
      end
    end
  end
  describe 'Events' do
    context 'when viewing' do
      it 'routes GET /events to Events#index' do
        {:get => '/events'}.should route_to(:controller => 'events', :action => 'index')
      end
      it 'routes GET /events/1 to Events#show' do
        {:get => '/events/1'}.should route_to(:controller => 'events', :action => 'show', :id => '1')
      end
    end
    context 'when joining' do
      it 'routes GET /events/1/join to Events#join' do
        {:get => '/events/1/join'}.should route_to(:controller => 'events', :action => 'join', :id => '1')
      end
      it 'routes GET /events/1/unjoin to Events#unjoin' do
        {:get => '/events/1/unjoin'}.should route_to(:controller => 'events', :action => 'unjoin', :id => '1')
      end
    end
    context 'when adding' do
      it 'routes GET /events/new to Events#new' do
        {:get => '/events/new'}.should route_to(:controller => 'events', :action => 'new')
      end
      it 'routes POST /events/create to Events#create' do
        {:post => '/events'}.should route_to(:controller => 'events', :action => 'create')
      end
    end
    context 'when updating' do
      it 'routes GET /events/1/edit to Events#edit' do
        {:get => '/events/1/edit'}.should route_to(:controller => 'events', :action => 'edit', :id => '1')
      end
      it 'routes PUT /events/1 to Events#update' do
        {:put => '/events/1'}.should route_to(:controller => 'events', :action => 'update', :id => '1')
      end
    end
    context 'when removing' do
      it 'routes GET /events/1/delete to Events#delete' do
        {:get => '/events/1/delete'}.should route_to(:controller => 'events', :action => 'delete', :id => '1')
      end
      it 'routes DELETE /events/1 to Events#destroy' do
        {:delete => '/events/1'}.should route_to(:controller => 'events', :action => 'destroy', :id => '1')
      end
    end
    describe 'Constraints' do
      context 'when viewing' do
        it 'routes GET /events/1/constraints to Constraints#index' do
          {:get => '/events/1/constraints'}.should route_to(:controller => 'constraints', :action => 'index', :event_id => '1')
        end
      end
      context 'when adding' do
        it 'routes GET /events/1/constraints/new to Constraints#new' do
          {:get => '/events/1/constraints/new'}.should route_to(:controller => 'constraints', :action => 'new', :event_id => '1')
        end
        it 'routes POST /events/1/constraints to Constraints#create' do
          {:post => '/events/1/constraints'}.should route_to(:controller => 'constraints', :action => 'create', :event_id => '1')
        end
      end
      context 'when removing' do
        it 'routes GET /events/1/constraints/1/delete to Constraints#delete' do
          {:get => '/events/1/constraints/1/delete'}.should route_to(:controller => 'constraints', :action => 'delete', :id => '1', :event_id => '1')
        end
        it 'routes DELETE /events/1/constraints/1 to Constraints#destroy' do
          {:delete => '/events/1/constraints/1'}.should route_to(:controller => 'constraints', :action => 'destroy', :id => '1', :event_id => '1')
        end
      end
    end
    describe 'Goals' do
      context 'when viewing' do
        it 'routes GET /events/1/goals to Goals#index' do
          {:get => '/events/1/goals'}.should route_to(:controller => 'goals', :action => 'index', :event_id => '1')
        end
      end
      context 'when adding' do
        it 'routes GET /events/1/goals/new to Goals#new' do
          {:get => '/events/1/goals/new'}.should route_to(:controller => 'goals', :action => 'new', :event_id => '1')
        end
        it 'routes POST /events/1/goals to Goals#create' do
          {:post => '/events/1/goals'}.should route_to(:controller => 'goals', :action => 'create', :event_id => '1')
        end
      end
      context 'when removing' do
        it 'routes GET /events/1/goals/1/delete to Goals#delete' do
          {:get => '/events/1/goals/1/delete'}.should route_to(:controller => 'goals', :action => 'delete', :id => '1', :event_id => '1')
        end
        it 'routes DELETE /events/1/goals/1 to Goals#destroy' do
          {:delete => '/events/1/goals/1'}.should route_to(:controller => 'goals', :action => 'destroy', :id => '1', :event_id => '1')
        end
      end
    end
    describe 'HostFieldTypes' do
      context 'when viewing' do
        it 'routes GET /events/1/host_field_types to HostFieldTypes#index' do
          {:get => '/events/1/host_field_types'}.should route_to(:controller => 'host_field_types', :action => 'index', :event_id => '1')
        end
      end
      context 'when adding' do
        it 'routes GET /events/1/host_field_types/new to HostFieldTypes#new' do
          {:get => '/events/1/host_field_types/new'}.should route_to(:controller => 'host_field_types', :action => 'new', :event_id => '1')
        end
        it 'routes POST /events/1/host_field_types to HostFieldTypes#create' do
          {:post => '/events/1/host_field_types'}.should route_to(:controller => 'host_field_types', :action => 'create', :event_id => '1')
        end
      end
      context 'when updating' do
        it 'routes GET /events/1/host_field_types/1/edit to HostFieldTypes#edit' do
          {:get => '/events/1/host_field_types/1/edit'}.should route_to(:controller => 'host_field_types', :action => 'edit', :id => '1', :event_id => '1')
        end
        it 'routes PUT /events/1/host_field_types/1 to HostFieldTypes#update' do
          {:put => '/events/1/host_field_types/1'}.should route_to(:controller => 'host_field_types', :action => 'update', :id => '1', :event_id => '1')
        end
      end
      context 'when removing' do
        it 'routes GET /events/1/host_field_types/1/delete to HostFieldTypes#delete' do
          {:get => '/events/1/host_field_types/1/delete'}.should route_to(:controller => 'host_field_types', :action => 'delete', :id => '1', :event_id => '1')
        end
        it 'routes DELETE /events/1/host_field_types/1 to HostFieldTypes#destroy' do
          {:delete => '/events/1/host_field_types/1'}.should route_to(:controller => 'host_field_types', :action => 'destroy', :id => '1', :event_id => '1')
        end
      end
    end
    describe 'VisitorFieldTypes' do
      context 'when viewing' do
        it 'routes GET /events/1/visitor_field_types to VisitorFieldTypes#index' do
          {:get => '/events/1/visitor_field_types'}.should route_to(:controller => 'visitor_field_types', :action => 'index', :event_id => '1')
        end
      end
      context 'when adding' do
        it 'routes GET /events/1/visitor_field_types/new to VisitorFieldTypes#new' do
          {:get => '/events/1/visitor_field_types/new'}.should route_to(:controller => 'visitor_field_types', :action => 'new', :event_id => '1')
        end
        it 'routes POST /events/1/visitor_field_types to VisitorFieldTypes#create' do
          {:post => '/events/1/visitor_field_types'}.should route_to(:controller => 'visitor_field_types', :action => 'create', :event_id => '1')
        end
      end
      context 'when updating' do
        it 'routes GET /events/1/visitor_field_types/1/edit to VisitorFieldTypes#edit' do
          {:get => '/events/1/visitor_field_types/1/edit'}.should route_to(:controller => 'visitor_field_types', :action => 'edit', :id => '1', :event_id => '1')
        end
        it 'routes PUT /events/1/visitor_field_types/1 to VisitorFieldTypes#update' do
          {:put => '/events/1/visitor_field_types/1'}.should route_to(:controller => 'visitor_field_types', :action => 'update', :id => '1', :event_id => '1')
        end
      end
      context 'when removing' do
        it 'routes GET /events/1/visitor_field_types/1/delete to VisitorFieldTypes#delete' do
          {:get => '/events/1/visitor_field_types/1/delete'}.should route_to(:controller => 'visitor_field_types', :action => 'delete', :id => '1', :event_id => '1')
        end
        it 'routes DELETE /events/1/visitor_field_types/1 to VisitorFieldTypes#destroy' do
          {:delete => '/events/1/visitor_field_types/1'}.should route_to(:controller => 'visitor_field_types', :action => 'destroy', :id => '1', :event_id => '1')
        end
      end
    end
    describe 'Hosts' do
      describe 'Rankings' do
        context 'when adding' do
          it 'routes GET /events/1/hosts/1/rankings/add to HostRankings#add' do
            {:get => '/events/1/hosts/1/rankings/add'}.should route_to(:controller => 'host_rankings', :action => 'add', :host_id => '1', :event_id => '1')
          end
        end
        context 'when updating' do
          it 'routes GET /events/1/hosts/1/rankings/edit_all to HostRankings#edit_all' do
            {:get => '/events/1/hosts/1/rankings/edit_all'}.should route_to(:controller => 'host_rankings', :action => 'edit_all', :host_id => '1', :event_id => '1')
          end
          it 'routes PUT /events/1/hosts/1/rankings/update_all to HostRankings#update_all' do
            {:put => '/events/1/hosts/1/rankings/update_all'}.should route_to(:controller => 'host_rankings', :action => 'update_all', :host_id => '1', :event_id => '1')
          end
        end
      end
      describe 'Availabilities' do
        context 'when updating' do
          it 'routes GET /events/1/hosts/1/availabilities/edit_all to HostAvailabilities#edit_all' do
            {:get => '/events/1/hosts/1/availabilities/edit_all'}.should route_to(:controller => 'host_availabilities', :action => 'edit_all', :host_id => '1', :event_id => '1')
          end
          it 'routes PUT /events/1/hosts/1/availabilities/update_all to HostAvailabilities#update_all' do
            {:put => '/events/1/hosts/1/availabilities/update_all'}.should route_to(:controller => 'host_availabilities', :action => 'update_all', :host_id => '1', :event_id => '1')
          end
        end
      end
      describe 'Meetings' do
        context 'when viewing' do
          it 'routes GET /events/1/hosts/1/meetings to Meetings#index' do
            {:get => '/events/1/hosts/1/meetings'}.should route_to(:controller => 'meetings', :action => 'index', :host_id => '1', :event_id => '1')
          end
        end
        context 'when updating' do
          it 'routes GET /events/1/hosts/1/meetings/tweak to Meetings#tweak' do
            {:get => '/events/1/hosts/1/meetings/tweak'}.should route_to(:controller => 'meetings', :action => 'tweak', :host_id => '1', :event_id => '1')
          end
          it 'routes POST /events/1/hosts/1/meetings/apply_tweaks to Meetings#apply_tweaks' do
            {:post => '/events/1/hosts/1/meetings/apply_tweaks'}.should route_to(:controller => 'meetings', :action => 'apply_tweaks', :host_id => '1', :event_id => '1')
          end
        end
      end
      context 'when viewing' do
        it 'routes GET /events/1/hosts to Hosts#index' do
          {:get => '/events/1/hosts'}.should route_to(:controller => 'hosts', :action => 'index', :event_id => '1')
        end
        it 'routes GET /events/1/hosts/1 to Hosts#show' do
          {:get => '/events/1/hosts/1'}.should route_to(:controller => 'hosts', :action => 'show', :event_id => '1', :id => '1')
        end
      end
      context 'when adding' do
        it 'routes GET /events/1/hosts/new to Hosts#new' do
          {:get => '/events/1/hosts/new'}.should route_to(:controller => 'hosts', :action => 'new', :event_id => '1')
        end
        it 'routes POST /events/1/hosts to Hosts#create' do
          {:post => '/events/1/hosts'}.should route_to(:controller => 'hosts', :action => 'create', :event_id => '1')
        end
        it 'routes GET /events/1/hosts/join to Hosts#join' do
          {:get => '/events/1/hosts/join'}.should route_to(:controller => 'hosts', :action => 'join', :event_id => '1')
        end
        it 'routes POST /events/1/hosts/create_from_current_user to Hosts#create_from_current_user' do
          {:post => '/events/1/hosts/create_from_current_user'}.should route_to(:controller => 'hosts', :action => 'create_from_current_user', :event_id => '1')
        end
      end
      context 'when editing' do
        it 'routes GET /events/1/hosts/edit to Hosts#edit' do
          {:get => '/events/1/hosts/1/edit'}.should route_to(:controller => 'hosts', :action => 'edit', :event_id => '1', :id => '1')
        end
        it 'routes PUT /events/1 to Hosts#update' do
          {:put => '/events/1/hosts/1'}.should route_to(:controller => 'hosts', :action => 'update', :event_id => '1', :id => '1')
        end
      end
      context 'when removing' do
        it 'routes GET /events/1/hosts/1/delete to Hosts#delete' do
          {:get => '/events/1/hosts/1/delete'}.should route_to(:controller => 'hosts', :action => 'delete', :event_id => '1', :id => '1')
        end
        it 'routes DELETE /events/1/hosts/1 to Hosts#destroy' do
          {:delete => '/events/1/hosts/1'}.should route_to(:controller => 'hosts', :action => 'destroy', :event_id => '1', :id => '1')
        end
        it 'routes DELETE /events/1/hosts/destroy_from_current_user to Hosts#destroy_from_current_user' do
          {:delete => '/events/1/hosts/destroy_from_current_user'}.should route_to(:controller => 'hosts', :action => 'destroy_from_current_user', :event_id => '1')
        end
      end
    end
    describe 'Visitors' do
      describe 'Rankings' do
        context 'when adding' do
          it 'routes GET /events/1/visitors/1/rankings/add to VisitorRankings#add' do
            {:get => '/events/1/visitors/1/rankings/add'}.should route_to(:controller => 'visitor_rankings', :action => 'add', :visitor_id => '1', :event_id => '1')
          end
        end
        context 'when updating' do
          it 'routes GET /events/1/visitors/1/rankings/edit_all to VisitorRankings#edit_all' do
            {:get => '/events/1/visitors/1/rankings/edit_all'}.should route_to(:controller => 'visitor_rankings', :action => 'edit_all', :visitor_id => '1', :event_id => '1')
          end
          it 'routes PUT /events/1/visitors/1/rankings/update_all to VisitorRankings#update_all' do
            {:put => '/events/1/visitors/1/rankings/update_all'}.should route_to(:controller => 'visitor_rankings', :action => 'update_all', :visitor_id => '1', :event_id => '1')
          end
        end
      end
      describe 'Availabilities' do
        context 'when updating' do
          it 'routes GET /events/1/visitors/1/availabilities/edit_all to VisitorAvailabilities#edit_all' do
            {:get => '/events/1/visitors/1/availabilities/edit_all'}.should route_to(:controller => 'visitor_availabilities', :action => 'edit_all', :visitor_id => '1', :event_id => '1')
          end
          it 'routes PUT /events/1/visitors/1/availabilities/update_all to VisitorAvailabilities#update_all' do
            {:put => '/events/1/visitors/1/availabilities/update_all'}.should route_to(:controller => 'visitor_availabilities', :action => 'update_all', :visitor_id => '1', :event_id => '1')
          end
        end
      end
      describe 'Meetings' do
        context 'when viewing' do
          it 'routes GET /events/1/visitors/1/meetings to Meetings#index' do
            {:get => '/events/1/visitors/1/meetings'}.should route_to(:controller => 'meetings', :action => 'index', :visitor_id => '1', :event_id => '1')
          end
        end
      end
      context 'when viewing' do
        it 'routes GET /events/1/visitors to Visitors#index' do
          {:get => '/events/1/visitors'}.should route_to(:controller => 'visitors', :action => 'index', :event_id => '1')
        end
        it 'routes GET /events/1/visitors/1 to Visitors#show' do
          {:get => '/events/1/visitors/1'}.should route_to(:controller => 'visitors', :action => 'show', :event_id => '1', :id => '1')
        end
      end
      context 'when adding' do
        it 'routes GET /events/1/visitors/new to Visitors#new' do
          {:get => '/events/1/visitors/new'}.should route_to(:controller => 'visitors', :action => 'new', :event_id => '1')
        end
        it 'routes POST /events/1/visitors to Hosts#create' do
          {:post => '/events/1/visitors'}.should route_to(:controller => 'visitors', :action => 'create', :event_id => '1')
        end
        it 'routes GET /events/1/visitors/join to Visitors#join' do
          {:get => '/events/1/visitors/join'}.should route_to(:controller => 'visitors', :action => 'join', :event_id => '1')
        end
        it 'routes POST /events/1/visitors/create_from_current_user to Visitors#create_from_current_user' do
          {:post => '/events/1/visitors/create_from_current_user'}.should route_to(:controller => 'visitors', :action => 'create_from_current_user', :event_id => '1')
        end
      end
      context 'when editing' do
        it 'routes GET /events/1/visitors/edit to Visitors#edit' do
          {:get => '/events/1/visitors/1/edit'}.should route_to(:controller => 'visitors', :action => 'edit', :event_id => '1', :id => '1')
        end
        it 'routes PUT /events/1 to Visitors#update' do
          {:put => '/events/1/visitors/1'}.should route_to(:controller => 'visitors', :action => 'update', :event_id => '1', :id => '1')
        end
      end
      context 'when removing' do
        it 'routes GET /events/1/visitors/1/delete to Visitors#delete' do
          {:get => '/events/1/visitors/1/delete'}.should route_to(:controller => 'visitors', :action => 'delete', :event_id => '1', :id => '1')
        end
        it 'routes DELETE /events/1/visitors/1 to Visitors#destroy' do
          {:delete => '/events/1/visitors/1'}.should route_to(:controller => 'visitors', :action => 'destroy', :event_id => '1', :id => '1')
        end
        it 'routes DELETE /events/1/visitors/destroy_from_current_user to Visitors#destroy_from_current_user' do
          {:delete => '/events/1/visitors/destroy_from_current_user'}.should route_to(:controller => 'visitors', :action => 'destroy_from_current_user', :event_id => '1')
        end
      end
    end
    describe 'Meetings' do
      context 'when viewing' do
        it 'routes GET /events/1/meetings to Meetings#index' do
          {:get => '/events/1/meetings'}.should route_to(:controller => 'meetings', :action => 'index', :event_id => '1')
        end
      end
      context 'when generating' do
        it 'routes GET /events/1/meetings/create_all to Meetings#create_all' do
          {:get => '/events/1/meetings/create_all'}.should route_to(:controller => 'meetings', :action => 'create_all', :event_id => '1')
        end
      end
    end
  end
end
