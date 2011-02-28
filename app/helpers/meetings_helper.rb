module MeetingsHelper

  def room_if_not_default(meeting)
    meeting.room == meeting.faculty.default_room ? '' : h(meeting.room)
  end

end
