class AvailabilitiesController < ApplicationController
  # GET /events/1/hosts/1/availabilities/edit_all
  # GET /events/1/visitors/1/availabilities/edit_all
  def edit_all
    @schedulable = get_schedulable
    event = Event.find(params[:event_id])

    if event.disable_hosts? && @current_user.class == Faculty ||
       event.disable_facilitators? && @current_user.class == PeerAdvisor
      flash[:alert] = t('availabilities.edit_all.disabled')
    end
  end

  # PUT /events/1/hosts/1/availabilities/update_all
  # PUT /events/1/visitors/1/availabilities/update_all
  def update_all
    @schedulable = get_schedulable

    if @schedulable.update_attributes(params[@schedulable.class.name.underscore.to_sym])
      flash[:notice] = t(:success, :scope => [@schedulable.class.name.tableize, :update])
      redirect_to :action => 'edit_all'
    else
      render 'edit_all'
    end
  end
end
