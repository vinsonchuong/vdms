class VisitorsController < RolesController

  private

  def get_role(event)
    unless params[:id].nil?
      event.visitors.find(params[:id])
    else
      event.visitors.build(params[:visitor])
    end
  end

  def get_roles(event)
    event.visitors
  end

  def get_attributes
    params[:visitor]
  end

  def get_i18n_scope
    :visitors
  end
end
