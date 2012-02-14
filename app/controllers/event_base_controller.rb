class EventBaseController < ApplicationController
  prepend_before_filter :process_token
  prepend_before_filter :set_event
  before_filter :set_current_role
  before_filter :show_join_prompt

  private

  def process_token
    auth_token = params[:auth_token] || request.headers['auth_token']
    unless auth_token.blank?
      user = Person.find(:first, :conditions => ['lower(email) = ?', auth_token])
      if not user.nil? and user.visitor_events.include?(@event)
        @skip_cas = true
        @current_user = user
        @auth_token = auth_token
      end
    end
  end

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
