module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name
    when /the home\s?page/ then root_path

    when /the view people page/ then people_path
    when /the new person page/ then new_person_path
    when /the import people page/ then upload_people_path
    when /the edit person page/ then edit_person_path(@staff)
    when /the remove person page/ then delete_person_path(@staff)

    when /the view events page/ then events_path
    when /the new event page/ then new_event_path
    when /the edit event page/ then edit_event_path(@event)
    when /the remove event page/ then delete_event_path(@event)

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
