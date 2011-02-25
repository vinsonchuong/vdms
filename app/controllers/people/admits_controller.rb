class AdmitsController < PeopleController
  before_filter :get_areas_and_divisions, :only => [:new, :edit, :create, :update, :view_meetings]
  before_filter :get_faculty, :only => [:rank_faculty, :update]

  # GET /people/admits/1/meetings
  def view_meetings
    @admit = Admit.find(params[:id])
    @admit_meetings = @admit.meetings
  end


  # GET /people/admits/1/schedule
  def schedule
    @admit = Admit.find(params[:id])
    @origin_action = 'schedule'
    @redirect_action = 'schedule'

    settings = Settings.instance
    @admit.build_available_times(settings.divisions.map(&:available_times).flatten, settings.meeting_length, settings.meeting_gap)
  end

  # GET /people/admits/1/rank_faculty
  def rank_faculty
    @admit = Admit.find(params[:id])
    @admit.faculty_rankings.build
    @origin_action = 'rank_faculty'
    @redirect_action = 'rank_faculty'
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
    @divisions = settings.divisions.map {|d| [d.long_name, d.name]}.sort!
  end

  def get_faculty
    @faculty = Faculty.all.sort! {|x, y| x.last_name <=> y.last_name}
  end
end
