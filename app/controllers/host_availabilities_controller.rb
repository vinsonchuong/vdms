class HostAvailabilitiesController < AvailabilitiesController

  private

  def get_schedulable
    @event.hosts.find(params[:host_id])
  end
end
