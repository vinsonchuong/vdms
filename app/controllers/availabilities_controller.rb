class AvailabilitiesController < ApplicationController
  # GET /people/PEOPLE/1/availabilities/edit_all
  def edit_all
    @schedulable = get_schedulable
    settings = Settings.instance

    if settings.disable_faculty && @current_user.class == Faculty ||
       settings.disable_peer_advisors && @current_user.class == PeerAdvisor
      flash[:alert] = t('availabilities.edit_all.disabled')
    end
  end

  # PUT /people/PEOPLE/1/availabilities/update_all
  def update_all
    @schedulable = get_schedulable

    if @schedulable.update_attributes(params[@schedulable.class.name.underscore.to_sym])
      flash[:notice] = t(:success, :scope => [:people, @schedulable.class.name.tableize, :update])
      redirect_to :action => 'edit_all'
    else
      render 'edit_all'
    end
  end
end
