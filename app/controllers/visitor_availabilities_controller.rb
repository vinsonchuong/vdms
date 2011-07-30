class VisitorAvailabilitiesController < AvailabilitiesController

  private

  def get_schedulable
    Admit.find(params[:admit_id])
  end
end
