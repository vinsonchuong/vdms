class HostFieldTypesController < FieldTypesController
  private

  def get_field_types
    @event.host_field_types
  end

  def get_field_type(attributes = {})
    if !params[:id].nil?
      @event.host_field_types.find(params[:id])
    elsif !params[:host_field_type].nil?
      @event.host_field_types.build(params[:host_field_type].merge!(attributes))
    else
      @event.host_field_types.build(attributes)
    end
  end

  def get_attributes
    params[:host_field_type]
  end

  def get_i18n_scope
    :host_field_types
  end

  def get_view_path
    '/host_field_types'
  end
end
