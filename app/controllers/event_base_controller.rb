class EventBaseController < ApplicationController
  before_filter :set_event
  before_filter :set_current_role
  before_filter :verify_role

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_current_role
    @current_role = @event.roles.find_by_person_id(@current_user.id)
  end

  def verify_role
    session[:after_verify_url] = request.url
    redirect_to(
      :controller => @current_role.class.name.tableize,
      :action => 'edit',
      :event_id => @event.id,
      :id => @current_role.id
    ) unless @current_role.nil? || @current_role.verified?
  end
end
