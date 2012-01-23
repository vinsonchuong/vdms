class EventBaseController < ApplicationController
  before_filter :set_event
  before_filter :set_current_role

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_current_role
    @current_role = @event.roles.find_by_person_id(@current_user.id)
  end
end
