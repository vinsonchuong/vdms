class VisitorAvailabilitiesController < AvailabilitiesController

  private

  def get_schedulable
    Visitor.find(params[:visitor_id])
  end
end
