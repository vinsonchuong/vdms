class FacultiesController < PeopleController
  # GET /people/staff/1/schedule
  def schedule
    @faculty = Faculty.find(params[:id])
    @faculty.build_available_times
  end

  # PUT /people/staff/1
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
