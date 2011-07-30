class HostAvailabilitiesController < AvailabilitiesController

  private

  def get_schedulable
    Faculty.find(params[:faculty_instance_id])
  end
end
