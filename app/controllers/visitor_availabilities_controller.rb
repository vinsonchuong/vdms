class VisitorAvailabilitiesController < AvailabilitiesController

  private

  def get_schedulable
    @event.visitors.find(params[:visitor_id])
  end
end
