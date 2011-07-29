class AdmitsController < PeopleController
  before_filter :get_areas_and_divisions, :only => [:new, :edit, :create, :update, :view_meetings]

  # GET /people/admits/1/edit_availability
  def edit_availability
    @admit = Admit.find(params[:id])
#    settings = Settings.instance
#    @admit.build_time_slots(settings.divisions.map(&:time_slots).flatten, settings.meeting_length, settings.meeting_gap)

    if Settings.instance.disable_peer_advisors && @current_user.class == PeerAdvisor
      flash[:alert] = t('people.admits.edit_availability.disabled')
    end

    @origin_action = 'edit_availability'
    @redirect_action = 'edit_availability'
  end

  private

  def get_model
    @model = Admit
    @collection = 'admits'
    @instance = 'admit'
  end

  def get_areas_and_divisions
    settings = Settings.instance
    @areas = settings.areas.map {|k, v| [v, k]}.sort!
    @divisions = settings.divisions.map {|k, v| [v, k]}.sort!
  end

  def get_faculty
    @faculty = Faculty.by_name
  end
end
