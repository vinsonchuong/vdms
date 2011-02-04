class FacultiesController < PeopleController
  
  # GET /people/faculty/1/area_of_interests
  def area_of_interests
    @faculty = Faculty.find(params[:id])
    @list_of_area_of_interests = ["Artificial Intelligence", "Biosystems & Computational Biology", "Communications & Networking",
      "Computer Architecture & Engineering", "Control, Intelligent Systems, and Robotics", "Database Management Systems",
      "Design of Electronic Systems", "Education", "Energy", "Graphics", "Human-Computer Interaction", "Integrated Circuits", 
      "Micro/Nano Electro Mechanical Systems", "Operating Systems & Networking", "Physical Electronics", "Programming Systems", 
      "Scientific Computing", "Security", "Signal Processing", "Theory"]
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
