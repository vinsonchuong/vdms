class EventBaseController < ApplicationController
  before_filter :set_event
  before_filter :set_current_role
  before_filter :show_join_prompt

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_current_role
    @current_role = @event.roles.find_by_person_id(@current_user.id)
  end

  def show_join_prompt
    redirect_to(
      :controller => 'events',
      :action => 'join',
      :id => @event.id
    ) if @current_role.nil? and @current_user.role == 'user'
  end
end
