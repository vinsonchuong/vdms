class FacultyController < PeopleController
  before_filter :get_areas_and_divisions, :only => [:new, :edit, :create, :update]

  # GET /people/faculty/1/new
  def new
    @faculty_instance = (@current_user.new_record?) ? @current_user : Faculty.new
  end

  # GET /people/faculty/1/edit_availability
  def edit_availability
    settings = Settings.instance
    @faculty_instance = Faculty.find(params[:id])
    @faculty_instance.build_available_times(settings.meeting_times(@faculty_instance.division), settings.meeting_length, settings.meeting_gap)
    @origin_action = 'edit_availability'
    @redirect_action = 'edit_availability'
  end

  # GET /people/faculty/1/rank_admits
  def rank_admits
    @faculty_instance = Faculty.find(params[:id])

    unless params[:select].nil?
      new_admits = Admit.find(params[:select].select {|admit, checked| checked.to_b}.map(&:first))
      new_admits.each {|a| @faculty_instance.admit_rankings.build(:admit => a, :rank => 1)}
    end

    @origin_action = 'rank_admits'
    @redirect_action = 'rank_admits'
  end

  # GET /people/faculty/1/select_admits
  def select_admits
    @faculty_instance = Faculty.find(params[:id])
    if params[:filter].nil?
      @areas = Settings.instance.areas.keys.sort!.map {|a| [a, true]}
      @admits = Admit.by_name
    else
      @areas = params[:filter].update_values(&:to_b).to_a.sort
      filter_areas = @areas.select {|area, checked| checked}.map(&:first)
      @admits = Admit.with_areas(*filter_areas)
    end
    @admits -= @faculty_instance.admit_rankings.map(&:admit)
  end

  private

  def get_model
    @model = Faculty
    @collection = 'faculty'
    @instance = 'faculty_instance'
  end

  def get_areas_and_divisions
    settings = Settings.instance
    @areas = settings.areas.map {|k, v| [v, k]}.sort!
    @divisions = settings.divisions.map {|d| [d.long_name, d.name]}.sort!
  end
end
