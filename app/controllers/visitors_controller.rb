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
    puts params.inspect
    params[:visitor]
  end

  def get_i18n_scope
    :visitors
  end
end
