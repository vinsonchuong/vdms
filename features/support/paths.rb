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
    when /the edit person page/ then edit_person_path(@person)
    when /the remove person page/ then delete_person_path(@person)

    when /the view events page/ then events_path
    when /the new event page/ then new_event_path
    when /the view event page/ then event_path(@event)
    when /the edit event page/ then edit_event_path(@event)
    when /the remove event page/ then delete_event_path(@event)

    when /the view hosts page/ then event_hosts_path(@event)
    when /the new host page/ then new_event_host_path(@event)
    when /the view host page/ then event_host_path(@event, @host)
    when /the edit host page/ then edit_event_host_path(@event, @host)
    when /the remove host page/ then remove_event_host_path(@event, @host)

    when /the edit host availability page/ then edit_all_event_host_availabilities_path(@event, @host)
    when /the rank visitors page/ then edit_all_event_host_rankings_path(@event, @host)
    when /the select visitors page/ then add_event_host_rankings_path(@event, @host)

    when /the view visitors page/ then event_visitors_path(@event)
    when /the new visitor page/ then new_event_visitor_path(@event)
    when /the view visitor page/ then event_visitor_path(@event, @visitor)
    when /the edit visitor page/ then edit_event_visitor_path(@event, @visitor)
    when /the remove visitor page/ then remove_event_visitor_path(@event, @visitor)

    when /the edit visitor availability page/ then edit_all_event_visitor_availabilities_path(@event, @visitor)
    when /the rank hosts page/ then edit_all_event_visitor_rankings_path(@event, @visitor)
    when /the select hosts page/ then add_event_visitor_rankings_path(@event, @visitor)

    when /the import faculty page/ then upload_people_path
    when /the view faculty meeting schedule page$/ then event_host_meetings_path(@event.hosts.find_by_person_id(@current_user.id))
    when /the view faculty meeting schedule page for "(.*) (.*)"/ then event_host_meetings_path(@event.hosts.find_by_person_id(Person.find_by_first_name_and_last_name($1,$2).id))
    when /the tweak faculty schedule page for "(.*) (.*)"/ then tweak_event_host_meetings_path(@event.hosts.find_by_person_id(Person.find_by_first_name_and_last_name($1,$2).id))

    when /the import admits page/ then upload_people_path
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
