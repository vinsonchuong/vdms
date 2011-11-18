class VisitorFieldTypesController < FieldTypesController
  private

  def get_field_types
    @event.visitor_field_types
  end

  def get_field_type(attributes = {})
    if !params[:id].nil?
      @event.visitor_field_types.find(params[:id])
    elsif !params[:visitor_field_type].nil?
      @event.visitor_field_types.build(params[:visitor_field_type].merge!(attributes))
    else
      @event.visitor_field_types.build(attributes)
    end
  end

  def get_attributes
    params[:visitor_field_type]
  end

  def get_i18n_scope
    :visitor_field_types
  end

  def get_view_path
    '/visitor_field_types'
  end
end
