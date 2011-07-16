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

  # GET /people/admits/1/rank_faculty
  def rank_faculty
    @admit = Admit.find(params[:id])

    unless params[:select].nil?
      new_faculty = Faculty.find(params[:select].select {|f, checked| checked.to_b}.map(&:first))
      new_faculty.each {|f| @admit.faculty_rankings.build(:faculty => f, :rank => 1)}
    end

    if Settings.instance.disable_peer_advisors && @current_user.class == PeerAdvisor
      flash[:alert] = t('people.admits.rank_faculty.disabled')
    elsif @admit.faculty_rankings.empty?
      redirect_to(select_faculty_admit_url(@admit))
      return
    end

    @origin_action = 'rank_faculty'
    @redirect_action = 'rank_faculty'
  end

  # GET /people/admits/1/select_faculty
  def select_faculty
    @admit = Admit.find(params[:id])
    @faculty = Faculty.by_name - @admit.faculty_rankings.map(&:faculty)
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
