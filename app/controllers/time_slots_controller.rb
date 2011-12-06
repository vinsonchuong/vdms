class TimeSlotsController < EventBaseController
  respond_to :json

  # GET /events/1/time_slots
  def index
    @time_slots = @event.time_slots
    respond_with @event, @time_slots
  end
end
