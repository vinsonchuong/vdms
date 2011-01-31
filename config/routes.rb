ActionController::Routing::Routes.draw do |map|
  map.with_options :controller => 'root' do |root|
    root.home '', :action => 'home', :conditions => {:method => :get}
    root.sign_out 'sign_out', :action => 'sign_out', :conditions => {:method => :get}
    root.sign_out 'sign_out', :action => 'sign_out', :conditions => {:method => :delete}
    root.staff_dashboard 'staff', :action => 'staff_dashboard', :conditions => {:method => :get}
    root.peer_advisor_dashboard 'peer_advisor', :action => 'peer_advisor_dashboard', :conditions => {:method => :get}
    root.faculty_dashboard 'faculty', :action => 'faculty_dashboard', :conditions => {:method => :get}
    root.find_admits_in_area_of_interests 'find_admits_in_area_of_interests', :action => 'find_admits_in_area_of_interests'
  end

  map.resource :settings, :only => [:edit, :update]

  map.resources :staffs, :path_prefix => '/people',
    :except => [:show],
    :collection => {:upload => :get, :import => :post},
    :member => {:delete => :get}
  map.resources :peer_advisors, :path_prefix => '/people',
    :except => [:show],
    :collection => {:upload => :get, :import => :post},
    :member => {:delete => :get}
  map.resources :faculties, :path_prefix => '/people',
    :except => [:show],
    :collection => {:upload => :get, :import => :post},
    :member => {:schedule => :get, :delete => :get}
  map.resources :admits, :path_prefix => '/people',
    :except => [:show],
    :collection => {:upload => :get, :import => :post},
    :member => {:delete => :get}
end
