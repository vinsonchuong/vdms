class FieldTypesController < EventBaseController
  respond_to :html, :json

  # GET /events/1/host_field_types
  # GET /events/1/visitor_field_types
  def index
    @field_types = get_field_types
    respond_with @field_types
  end

  # GET /events/1/host_field_types/new
  # GET /events/1/visitor_field_types/new
  def new
    @data_types = FieldType.data_types_list.map {|k, v| [v, k]}
    if params[:data_type].nil?
      render :template => "#{get_view_path}/select_data_type"
    else
      @field_type = get_field_type(:data_type => params[:data_type])
    end
  end

  # GET /events/1/host_field_types/1/edit
  # GET /events/1/visitor_field_types/1/edit
  def edit
    @field_type = get_field_type
    @data_types = FieldType.data_types_list.map {|k, v| [v, k]}
  end

  # GET /events/1/host_field_types/1/delete
  # GET /events/1/visitor_field_types/1/delete
  def delete
    @field_type = get_field_type
  end

  # POST /events/1/host_field_types
  # POST /events/1/visitor_field_types
  def create
    @field_type = get_field_type
    if @field_type.save
      flash[:notice] = t('create.success', :scope => get_i18n_scope)
      redirect_to :action => 'index'
    else
      @data_types = FieldType.data_types_list.map {|k, v| [v, k]}
      render :action => 'new'
    end
  end

  # PUT /events/1/host_field_types/1
  # PUT /events/1/visitor_field_types/1
  def update
    @field_type = get_field_type
    if @field_type.update_attributes(get_attributes)
      flash[:notice] = t('update.success', :scope => get_i18n_scope)
      redirect_to :action => 'index'
    else
      @data_types = FieldType.data_types_list.map {|k, v| [v, k]}
      render :action => 'edit'
    end
  end

  # DELETE /events/1/host_field_types/1
  # DELETE /events/1/visitor_field_types/1
  def destroy
    get_field_type.destroy
    flash[:notice] = t('destroy.success', :scope => get_i18n_scope)
    redirect_to :action => 'index'
  end
end
