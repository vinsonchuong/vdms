class HostsController < RolesController

  private

  def get_role(attributes = {})
    if !params[:id].nil?
      @event.hosts.find(params[:id])
    elsif !params[:host].nil?
      @event.hosts.build(params[:host].merge!(attributes))
    else
      @event.hosts.build(attributes)
    end
  end

  def create_role(attributes = {})
    @event.hosts.create(attributes)
  end

  def get_roles
    @event.hosts
  end

  def get_attributes
    params[:host] || {}
  end

  def get_i18n_scope
    :hosts
  end
end
