class AdmitsController < PeopleController
  before_filter :get_areas_and_divisions, :only => [:new, :edit, :create, :update]
  before_filter :get_faculty, :only => [:rank_faculty, :update]

  # GET /people/PEOPLE/admits/filter
  def filter
      @areas =  Settings.instance.areas
      @divisions = Settings.instance.divisions.map(&:name)
      @admits = []
      
      if params[:commit] == "Filter Admits"
        params[:filter][:divisions].collect {|division, checked| @admits += Admit.find_all_by_division(division) if checked == "1" }
        params[:filter][:areas].collect {|area, checked| @admits += Admit.find(:all, :conditions => ["area1 = ? OR area2 = ?", area, area]) if checked == "1"}
        @admits.uniq!
      end   
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
    @areas = settings.areas.values
    @divisions = settings.divisions.map(&:long_name)
  end

  def get_faculty
    @faculty = Faculty.all.sort! {|x, y| x.last_name <=> y.last_name}
  end
end
