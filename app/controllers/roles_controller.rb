class RolesController < ApplicationController
  # GET /events/1/hosts
  # GET /events/1/visitors
  def index
    @event = Event.find(params[:event_id])
    @roles = get_roles(@event)
  end

  # GET /events/1/hosts/1
  # GET /events/1/visitors/1
  def show
    @event = Event.find(params[:event_id])
    @role = get_role(@event)
  end

  # GET /events/1/hosts/new
  # GET /events/1/visitors/new
  def new
    @people = Person.all
    @event = Event.find(params[:event_id])
    @role = get_role(@event)
  end

  # GET /events/1/hosts/1/edit
  # GET /events/1/visitors/1/edit
  def edit
    @event = Event.find(params[:event_id])
    @role = get_role(@event)
  end

  # GET /events/1/hosts/1/delete
  # GET /events/1/visitors/1/delete
  def delete
    @event = Event.find(params[:event_id])
    @role = get_role(@event)
  end

  # POST /events/1/hosts
  # POST /events/1/visitors
  def create
    @event = Event.find(params[:event_id])
    @role = get_role(@event)
    if @role.save
      flash[:notice] = t('create.success', :scope => get_i18n_scope)
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  # PUT /events/1/hosts/1
  # PUT /events/1/visitors/1
  def update
    @event = Event.find(params[:event_id])
    @role = get_role(@event)
    if @role.update_attributes(get_attributes)
      flash[:notice] = t('update.success', :scope => get_i18n_scope)
      redirect_to :action => 'index'
    else
      render :action => 'edit'
    end
  end

  # DESTROY /events/1/hosts/1
  # DESTROY /events/1/visitors/1
  def destroy
    get_role(Event.find(params[:event_id])).destroy
    flash[:notice] = t('destroy.success', :scope => get_i18n_scope)
    redirect_to :action => 'index'
  end
end
