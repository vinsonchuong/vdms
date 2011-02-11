class FacultiesController < PeopleController
    
  # GET /people/admits/1/rank_admits
  def rank_admits
    puts params
    @faculty = Faculty.find(params[:id])
    params[:admits].each {|admit_id, checked| @faculty.admit_rankings.build(:admit_id => admit_id) if checked == "1" && !@faculty.admit_rankings.find_by_admit_id(admit_id)} if params[:admits]
  end

  # GET /people/faculty/1/schedule
  def schedule
    @faculty = Faculty.find(params[:id])

    settings = Settings.instance
    @faculty.build_available_times(settings.meeting_times(@faculty.division), settings.meeting_length, settings.meeting_gap)
  end

  # PUT /people/faculty/1
  def update
    @faculty = Faculty.find(params[:id])

    if @faculty.update_attributes(params[:faculty])
      if @current_user.class == Staff
        redirect_to(faculties_url, :notice => "Faculty was successfully updated.")
      else
        redirect_to(faculty_dashboard_url, :notice => "Meeting availability was successfully updated")
      end
    else
      render :action => 'edit'
    end
  end

  private

  def set_model
    @model = Faculty
  end
end
