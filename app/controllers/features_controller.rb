class FeaturesController < EventBaseController
  respond_to :html, :json

  # GET /events/1/constraints
  # GET /events/1/goals
  def index
    @features = get_features
    respond_with @event, @features
  end

  # GET /events/1/constraints/new
  # GET /events/1/goals/new
  def new
    @feature = get_feature
    @host_field_types = @event.host_field_types.map {|t| [t.name, t.id]}
    @visitor_field_types = @event.visitor_field_types.map {|t| [t.name, t.id]}
    @feature_list = Feature.feature_list_for(@feature.host_field_type, @feature.visitor_field_type) unless @feature.host_field_type.nil? or @feature.visitor_field_type.nil?
    respond_with @event, @feature do |format|
      if @feature.host_field_type.nil? or @feature.visitor_field_type.nil?
        format.html {render :template => "#{get_view_path}/select_field_types"}
      elsif @feature.feature_type.blank?
        format.html {render :template => "#{get_view_path}/select_feature_type"}
      end
    end
  end

  # GET /events/1/constraints/1/edit
  # GET /events/1/goals/1/edit
  def edit
    @feature = get_feature
    @host_field_types = @event.host_field_types.map {|t| [t.name, t.id]}
    @visitor_field_types = @event.visitor_field_types.map {|t| [t.name, t.id]}
    @feature_list = Feature.feature_list_for(@feature.host_field_type, @feature.visitor_field_type)
    respond_with @event, @feature
  end

  # GET /events/1/constraints/1/delete
  # GET /events/1/goals/1/delete
  def delete
    @feature = get_feature
    respond_with @event, @feature
  end

  # POST /events/1/constraints
  # POST /events/1/goals
  def create
    @feature = get_feature
    if @feature.save
      flash[:notice] = t('create.success', :scope => get_i18n_scope) unless request.xhr?
    else
      @host_field_types = @event.host_field_types.map {|t| [t.name, t.id]}
      @visitor_field_types = @event.visitor_field_types.map {|t| [t.name, t.id]}
      @feature_list = Feature.feature_list_for(@feature.host_field_type, @feature.visitor_field_type)
    end
    respond_with @event, @feature, :location => {:action => 'index'}
  end

  # PUT /events/1/constraints/1
  # PUT /events/1/goals/1
  def update
    @feature = get_feature
    if @feature.update_attributes(get_attributes)
      flash[:notice] = t('update.success', :scope => get_i18n_scope) unless request.xhr?
    else
      @host_field_types = @event.host_field_types.map {|t| [t.name, t.id]}
      @visitor_field_types = @event.visitor_field_types.map {|t| [t.name, t.id]}
      @feature_list = Feature.feature_list_for(@feature.host_field_type, @feature.visitor_field_type)
    end
    respond_with @event, @feature, :location => {:action => 'index'}
  end

  # DELETE /events/1/constraints/1
  # DELETE /events/1/goals/1
  def destroy
    @feature = get_feature
    @feature.destroy
    flash[:notice] = t('destroy.success', :scope => get_i18n_scope) unless request.xhr?
    respond_with @event, @feature
  end
end
