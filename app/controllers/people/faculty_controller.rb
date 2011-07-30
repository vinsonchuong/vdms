class FacultyController < PeopleController
  before_filter :get_areas_and_divisions, :only => [:new, :edit, :create, :update]

  # GET /people/faculty
  def index
    @faculty = Faculty.by_name
  end

  # GET /people/faculty/1/new
  def new
    @faculty_instance = (@current_user.new_record?) ? @current_user : Faculty.new
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
    @divisions = settings.divisions.map {|k, v| [v, k]}.sort!
  end
end
