module MeetingsHelper

  def room_if_not_default(meeting,faculty)
    meeting.room == faculty.default_room ? '' : content_tag(:span, h(meeting.room), :class => 'room')
  end

end
