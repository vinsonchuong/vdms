class VisitorsController < RolesController

  private

  def get_role(attributes = {})
    if !params[:id].nil?
      @event.visitors.find(params[:id])
    elsif !params[:visitor].nil?
      @event.visitors.build(params[:visitor].merge!(attributes))
    else
      @event.visitors.build(attributes)
    end
  end

  def create_role(attributes = {})
    @event.visitors.create(attributes)
  end

  def get_roles
    @event.visitors
  end

  def get_attributes
    params[:visitor] || {}
  end

  def get_i18n_scope
    :visitors
  end

  def get_csv_column_names()
    ['Last Name', 'First Name', 'Email', 'Phone'] + @event.visitor_field_types.map(&:name)
  end
end
