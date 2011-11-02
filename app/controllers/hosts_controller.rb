class HostsController < RolesController

  private

  def get_role
    unless params[:id].nil?
      @event.hosts.find(params[:id])
    else
      @event.hosts.build(params[:host])
    end
  end

  def get_roles
    @event.hosts
  end

  def get_attributes
    params[:host]
  end

  def get_i18n_scope
    :hosts
  end
end
