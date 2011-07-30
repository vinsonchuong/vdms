class AdmitsController < PeopleController
  before_filter :get_areas_and_divisions, :only => [:new, :edit, :create, :update, :view_meetings]

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
