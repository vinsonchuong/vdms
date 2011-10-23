module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name
    when /the home\s?page/ then home_path
    when /the staff dashboard page/ then staff_dashboard_path
    when /the peer advisor dashboard page/ then peer_advisor_dashboard_path
    when /the faculty dashboard page/ then faculty_dashboard_path

    when /the update settings page/ then edit_event_path(@event || Factory.create(:event))

    when /the view staff page/ then people_path
    when /the new staff page/ then new_person_path
    when /the import staff page/ then upload_people_path
    when /the edit staff page/ then edit_person_path(@staff)
    when /the delete staff page/ then delete_person_path(@staff)

    when /the view peer advisors page/ then people_path
    when /the new peer advisor page/ then new_person_path
    when /the import peer advisors page/ then upload_people_path
    when /the edit peer advisor page/ then edit_person_path(@peer_advisor)
    when /the delete peer advisor page/ then delete_person_path(@peer_advisor)

    when /the view faculty page/ then people_path
    when /the new faculty page/ then new_person_path
    when /the import faculty page/ then upload_people_path
    when /the edit faculty page/ then edit_person_path(@faculty)
    when /the update faculty availability page/ then edit_all_event_host_availabilities_path(@event.hosts.find_by_person_id(@current_user.id))
    when /the rank admits page/ then edit_all_event_host_rankings_path(@event.hosts.find_by_person_id(@current_user.id))
    when /the select admits page/ then add_event_host_rankings_path(@event.hosts.find_by_person_id(@current_user.id))
    when /the delete faculty page/ then delete_faculty_instance_path(@faculty)
    when /the admit_ranking page/ then edit_all_event_host_rankings_path(@event.hosts.find_by_person_id(@current_user.id))
    when /the view faculty meeting schedule page$/ then event_host_meetings_path(@event.hosts.find_by_person_id(@current_user.id))
    when /the view faculty meeting schedule page for "(.*) (.*)"/ then event_host_meetings_path(@event.hosts.find_by_person_id(Person.find_by_first_name_and_last_name($1,$2).id))
    when /the tweak faculty schedule page for "(.*) (.*)"/ then tweak_event_host_meetings_path(@event.hosts.find_by_person_id(Person.find_by_first_name_and_last_name($1,$2).id))

    when /the view admits page/ then people_path
    when /the new admit page/ then new_person_path
    when /the import admits page/ then upload_people_path
    when /the edit admit page/ then edit_person_path(@admit)
    when /the update admit availability page/ then edit_all_event_visitor_availabilities_path(@event.visitors.find_by_person_id(@admit.id))
    when /the rank faculty page/ then edit_all_event_visitor_rankings_path(@event.visitors.find_by_person_id(@admit.id))
    when /the select faculty page/ then add_event_visitor_rankings_path(@event.visitors.find_by_person_id(@admit.id))
    when /the delete admit page/ then delete_admit_path(@admit)
    when /the view admit meeting schedule page$/ then event_visitor_meetings_path(@event.visitors.find_by_person_id(@admit.id))
    when /the view admit meeting schedule page for "(.*) (.*)"$/ then event_visitor_meetings_path(@event.visitors.find_by_person_id(Person.find_by_first_name_and_last_name($1, $2)))

    when /the master meetings page/  then event_meetings_path(:event => @event || Factory.create(:event))

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
