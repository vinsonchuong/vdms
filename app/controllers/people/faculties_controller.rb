class FacultiesController < PeopleController
  before_filter :get_areas_and_divisions, :only => [:new, :edit, :create, :update]

  # GET /people/faculty/1/new
  def new
    @faculty = (@current_user.new_record?) ? @current_user : Faculty.new
  end

  # GET /people/faculty/1/rank_admits
  def rank_admits
    puts params
    @faculty = Faculty.find(params[:id])
    @origin_action = 'rank_admits'
    @redirect_action = 'rank_admits'

    params[:admits].each {|admit_id, checked| @faculty.admit_rankings.build(:admit_id => admit_id) if checked == "1" && !@faculty.admit_rankings.find_by_admit_id(admit_id)} if params[:admits]
  end

  # GET /people/faculty/1/schedule
  def schedule
    settings = Settings.instance
    @faculty = Faculty.find(params[:id])
    @faculty.build_available_times(settings.meeting_times(@faculty.division), settings.meeting_length, settings.meeting_gap)
    @origin_action = 'schedule'
    @redirect_action = 'schedule'
  end

  # POST /people/faculty
  def create
    @faculty = Faculty.new(params[:faculty])
    @faculty.ldap_id = @current_user.ldap_id if @current_user.new_record?

    if @faculty.save
      redirect_to(faculties_url, :notice => 'Faculty was successfully added.')
    else
      render :action => 'new'
    end
  end

  private

  def get_model
    @model = Faculty
  end

  def get_areas_and_divisions
    settings = Settings.instance
    @areas = settings.areas.values
    @divisions = settings.divisions.map(&:long_name)
  end
end
