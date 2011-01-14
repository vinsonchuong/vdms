ActionController::Routing::Routes.draw do |map|
  map.with_options :controller => 'root' do |root|
    root.home '', :action => 'home', :conditions => {:method => :get}
    root.sign_out 'sign_out', :action => 'sign_out', :conditions => {:method => :get}
    root.sign_out 'sign_out', :action => 'sign_out', :conditions => {:method => :delete}
  end

  map.with_options :controller => 'staff', :name_prefix => 'staff_', :path_prefix => 'staff/' do |staff|
    staff.home '', :action => 'home', :conditions => {:method => :get}
  end

  map.with_options :controller => 'peer_advisor', :name_prefix => 'peer_advisor_', :path_prefix => 'peer_advisor/' do |peer_advisor|
    peer_advisor.home '', :action => 'home', :conditions => {:method => :get}
  end

  map.with_options :controller => 'faculty', :name_prefix => 'faculty_', :path_prefix => 'faculty/' do |faculty|
    faculty.home '', :action => 'home', :conditions => {:method => :get}
  end
end
