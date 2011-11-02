class VisitorsController < RolesController

  private

  def get_role
    unless params[:id].nil?
      @event.visitors.find(params[:id])
    else
      @event.visitors.build(params[:visitor])
    end
  end

  def get_roles
    @event.visitors
  end

  def get_attributes
    puts params.inspect
    params[:visitor]
  end

  def get_i18n_scope
    :visitors
  end
end
