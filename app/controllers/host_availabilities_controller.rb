class HostAvailabilitiesController < AvailabilitiesController

  private

  def get_schedulable
    Host.find(params[:host_id])
  end
end
