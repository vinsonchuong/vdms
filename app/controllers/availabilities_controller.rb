class AvailabilitiesController < EventBaseController
  # GET /events/1/hosts/1/availabilities/edit_all
  # GET /events/1/visitors/1/availabilities/edit_all
  def edit_all
    @schedulable = get_schedulable

    if @event.disable_hosts? && !@event.hosts.find_by_person_id(@current_user.id).nil? ||
       @event.disable_facilitators? && @current_user.role == 'facilitator'
      flash[:alert] = t('availabilities.edit_all.disabled')
    end
  end

  # PUT /events/1/hosts/1/availabilities/update_all
  # PUT /events/1/visitors/1/availabilities/update_all
  def update_all
    @schedulable = get_schedulable

    if @schedulable.update_attributes(params[@schedulable.class.name.underscore.to_sym])
      flash[:notice] = t(@schedulable == @current_role ? :alt_success : :success,
                         :scope => [@schedulable.class.name.tableize, :update])
      redirect_to :action => 'edit_all'
    else
      render 'edit_all'
    end
  end
end
