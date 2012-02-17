class RolesController < EventBaseController
  respond_to :html, :json
  skip_before_filter :show_join_prompt, :only => [:join, :create_from_current_user]

  # GET /events/1/hosts
  # GET /events/1/visitors
  def index
    if params[:id].blank?
      @roles = get_roles
    else
      @roles = [get_role]
    end
    respond_with @event, @roles
  end

  # GET /events/1/hosts/1
  # GET /events/1/visitors/1
  def show
    @role = get_role
    respond_with @event, @role
  end

  # GET /events/1/hosts/new
  # GET /events/1/visitors/new
  def new
    @people = Person.all
    @role = get_role
    respond_with @event, @role
  end

  # GET /events/1/hosts/join
  # GET /events/1/visitors/join
  def join
  end

  # GET /events/1/hosts/1/edit
  # GET /events/1/visitors/1/edit
  def edit
    @role = get_role
    respond_with @event, @role
  end

  # GET /events/1/hosts/1/delete
  # GET /events/1/visitors/1/delete
  def delete
    @role = get_role
    respond_with @event, @role
  end

  # POST /events/1/hosts
  # POST /events/1/visitors
  def create
    @role = get_role
    flash[:notice] = t('create.success', :scope => get_i18n_scope) if @role.save and not request.xhr?
    respond_with @event, @role, :location => {:action => 'index'}
  end

  # POST /events/1/hosts/create_from_current_user
  # POST /events/1/visitors/create_from_current_user
  def create_from_current_user
    @role = create_role(:person => @current_user, :verified => true)
    @role.save
    redirect_to event_url(@event), :notice => "You have joined the event as a #{@role.class.name}"
  end

  # PUT /events/1/hosts/1
  # PUT /events/1/visitors/1
  def update
    @role = get_role
    if @role.update_attributes(get_attributes) and not request.xhr?
      flash[:notice] = t(@current_role == @role ?
                           'update.alt_success' :
                           'update.success',
                         :scope => get_i18n_scope)
    end
    respond_with @event, @role, :location => @current_user.role == 'user' ?
                                               @event :
                                               {:action => 'index'}
  end

  # DESTROY /events/1/hosts/1
  # DESTROY /events/1/visitors/1
  def destroy
    @role = get_role
    get_role.destroy
    flash[:notice] = t('destroy.success', :scope => get_i18n_scope) unless request.xhr?
    respond_with @event, @role
  end

  # DELETE /events/1/hosts/destroy_from_current_user
  # DELETE /events/1/visitors/destroy_from_current_user
  def destroy_from_current_user
    @current_role.nil? or @current_role.destroy
    redirect_to event_url(@event), :notice => 'You have unregistered from the event.'
  end
end
