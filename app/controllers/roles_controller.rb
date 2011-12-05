class RolesController < EventBaseController
  skip_before_filter :verify_role, :only => [:edit, :update]
  respond_to :html, :json

  # GET /events/1/hosts
  # GET /events/1/visitors
  def index
    @roles = get_roles
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
    @role = create_role(:person => @current_user)
    redirect_to event_url(@event)
  end

  # PUT /events/1/hosts/1
  # PUT /events/1/visitors/1
  def update
    @role = get_role
    was_verified = @role.verified?
    if @role.update_attributes(get_attributes.merge(:verified => @role == @current_role)) and not request.xhr?
      flash[:notice] = t(@current_role == @role ?
                           'update.alt_success' :
                           'update.success',
                         :scope => get_i18n_scope)
    end
    respond_with @event, @role, :location => @current_role == @role ?
                                               was_verified ?
                                                 @event :
                                                 session[:after_verify_url] :
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
end
