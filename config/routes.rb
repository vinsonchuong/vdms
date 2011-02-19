ActionController::Routing::Routes.draw do |map|
  map.with_options :controller => 'root' do |root|
    root.home '', :action => 'home', :conditions => {:method => :get}
    root.sign_out 'sign_out', :action => 'sign_out', :conditions => {:method => :get}
    root.sign_out 'sign_out', :action => 'sign_out', :conditions => {:method => :delete}
    root.staff_dashboard 'staff', :action => 'staff_dashboard', :conditions => {:method => :get}
    root.peer_advisor_dashboard 'peer_advisor', :action => 'peer_advisor_dashboard', :conditions => {:method => :get}
    root.faculty_dashboard 'faculty', :action => 'faculty_dashboard', :conditions => {:method => :get}
  end

  map.resource :settings, :only => [:edit, :update]

  map.resources :staff, :singular => 'staff_instance', :path_prefix => '/people',
    :except => [:show],
    :collection => {:upload => :get, :import => :post},
    :member => {:delete => :get}
  map.resources :peer_advisors, :path_prefix => '/people',
    :except => [:show],
    :collection => {:upload => :get, :import => :post},
    :member => {:delete => :get}
  map.resources :faculty, :singular => 'faculty_instance', :path_prefix => '/people',
    :except => [:show],
    :collection => {:upload => :get, :import => :post},
    :member => {:schedule => :get, :delete => :get, :rank_admits => :get}
  map.resources :admits, :path_prefix => '/people',
    :except => [:show],
    :collection => {:upload => :get, :import => :post, :filter => :get},
    :member => {:schedule => :get, :rank_faculty => :get, :delete => :get}
end
