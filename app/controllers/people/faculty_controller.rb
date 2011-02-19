class FacultyController < PeopleController
  before_filter :get_areas_and_divisions, :only => [:new, :edit, :create, :update]

  # GET /people/faculty/1/new
  def new
    @faculty_instance = (@current_user.new_record?) ? @current_user : Faculty.new
  end

  # GET /people/faculty/1/rank_admits
  def rank_admits
    puts params
    @faculty_instance = Faculty.find(params[:id])
    @origin_action = 'rank_admits'
    @redirect_action = 'rank_admits'

    params[:admits].each {|admit_id, checked| @faculty_instance.admit_rankings.build(:admit_id => admit_id) if checked == "1" && !@faculty_instance.admit_rankings.find_by_admit_id(admit_id)} if params[:admits]
  end

  # GET /people/faculty/1/schedule
  def schedule
    settings = Settings.instance
    @faculty_instance = Faculty.find(params[:id])
    @faculty_instance.build_available_times(settings.meeting_times(@faculty_instance.division), settings.meeting_length, settings.meeting_gap)
    @origin_action = 'schedule'
    @redirect_action = 'schedule'
  end

  # POST /people/faculty
  def create
    @faculty_instance = Faculty.new(params[:faculty])
    @faculty_instance.ldap_id = @current_user.ldap_id if @current_user.new_record?

    if @faculty_instance.save
      redirect_to(faculty_url, :notice => 'Faculty was successfully added.')
    else
      render :action => 'new'
    end
  end

  private

  def get_model
    @model = Faculty
    @collection = 'faculty'
    @instance = 'faculty_instance'
  end

  def get_areas_and_divisions
    settings = Settings.instance
    @areas = settings.areas.values
    @divisions = settings.divisions.map(&:long_name)
  end
end
