class RolesController < EventBaseController
  skip_before_filter :verify_role, :only => [:edit, :update]

  # GET /events/1/hosts
  # GET /events/1/visitors
  def index
    @roles = get_roles
  end

  # GET /events/1/hosts/1
  # GET /events/1/visitors/1
  def show
    @role = get_role
  end

  # GET /events/1/hosts/new
  # GET /events/1/visitors/new
  def new
    @people = Person.all
    @role = get_role
  end

  # GET /events/1/hosts/join
  # GET /events/1/visitors/join
  def join
  end

  # GET /events/1/hosts/1/edit
  # GET /events/1/visitors/1/edit
  def edit
    @role = get_role
  end

  # GET /events/1/hosts/1/delete
  # GET /events/1/visitors/1/delete
  def delete
    @role = get_role
  end

  # POST /events/1/hosts
  # POST /events/1/visitors
  def create
    @role = get_role
    if @role.save
      flash[:notice] = t('create.success', :scope => get_i18n_scope)
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
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
    if @role.update_attributes(get_attributes.merge(:verified => @role == @current_role))
      flash[:notice] = t(@current_role == @role ? 'update.alt_success' : 'update.success', :scope => get_i18n_scope)
      redirect_to @current_role == @role ?
                    was_verified ?
                      event_path(@event) :
                      session[:after_verify_url] :
                    {:action => 'index'}
    else
      render :action => 'edit'
    end
  end

  # DESTROY /events/1/hosts/1
  # DESTROY /events/1/visitors/1
  def destroy
    get_role.destroy
    flash[:notice] = t('destroy.success', :scope => get_i18n_scope)
    redirect_to :action => 'index'
  end
end
