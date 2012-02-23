class EventsController < ApplicationController
  prepend_before_filter :process_token, :only => [:show, :visitor_login]
  prepend_before_filter :skip_cas, :only => [:visitor_login_form, :visitor_login]

  # GET /events
  def index
    @user_events = @current_user.events
    @other_events = Event.all - @user_events
  end

  # GET /events/1
  def show
    @current_role = @event.roles.find_by_person_id(@current_user.id)
    redirect_to(
        :controller => 'events',
        :action => 'join',
        :id => @event.id
    ) if @current_role.nil? and @current_user.role == 'user'
    if !@current_role.nil? and @event.hosts.where(location_id: @current_role.location_id).count > 1
      flash[:alert] = 'Warning: Someone else has registered using your address.'
    end
  end

  # GET /events/1/visitor_login_form
  def visitor_login_form
    @current_user = Person.new
    @event = Event.find(params[:id])
  end

  # GET /events/1/visitor_login
  def visitor_login
    @event = Event.find(params[:id])
    if @current_user.nil?
      @current_user = Person.new
      flash[:alert] = 'We do not recognize this username.'
      render :action => 'visitor_login_form'
    else
      redirect_to event_path(@event, :auth_token => @auth_token)
    end
  end

  # GET /events/1/join
  def join
    @event = Event.find(params[:id])
    redirect_to @event unless @event.roles.find_by_person_id(@current_user.id).nil?
  end

  # GET /events/1/unjoin
  def unjoin
    @event = Event.find(params[:id])
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/edit
  def edit
    @event = Event.find(params[:id])
    @meeting_times = @event.meeting_times(:include_blank => true)
  end

  # GET /events/1/delete
  def delete
    @event = Event.find(params[:id])
  end

  # POST /events
  def create
    @event = Event.new(params[:event])
    if @event.save
      redirect_to(@event, :notice => t('events.create.success'))
    else
      render :action => 'new'
    end
  end

  # PUT /events/1
  def update
    @event = Event.find(params[:id])

    # Hack to address standing bug in Rails 2.3: time_select doesn't work with :include_blank
    # NOT tested in RSpec.
    unless params['event'].nil? || params['event']['meeting_times_attributes'].nil?
      params['event']['meeting_times_attributes'].each_pair do |i, time|
        unless time['end(4i)'].blank? || time['end(5i)'].blank?
          time['end(1i)'] = time['begin(1i)'].blank? ? '2011' : time['begin(1i)']
          time['end(2i)'] = time['begin(2i)'].blank? ? '1' : time['begin(2i)']
          time['end(3i)'] = time['begin(3i)'].blank? ? '1' : time['begin(3i)']
        end
      end
    end

    if @event.update_attributes(params[:event])
      redirect_to(edit_event_url, :notice => t(:success, :scope => [:events, :update]))
    else
      render :action => 'edit'
    end
  end

  # DELETE /events/1
  def destroy
    Event.find(params[:id]).destroy
    redirect_to(:events, :notice => t('events.destroy.success'))
  end

  private

  def skip_cas
    @skip_cas = true
  end

  def process_token
    @event = Event.find(params[:id])
    auth_token = params[:auth_token] || request.headers['X-AUTH-TOKEN']
    unless auth_token.blank?
      user = Person.find(:first, :conditions => ['lower(email) = ?', auth_token])
      if not user.nil? and user.visitor_events.include?(@event)
        @skip_cas = true
        @current_user = user
        @auth_token = auth_token
      end
    end
  end
end
