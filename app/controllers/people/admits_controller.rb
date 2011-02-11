class AdmitsController < PeopleController
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

    settings = Settings.instance
    @admit.build_available_times(settings.divisions.map(&:available_times).flatten, settings.meeting_length, settings.meeting_gap)
  end

  # GET /people/admits/1/rank_faculty
  def rank_faculty
    @admit = Admit.find(params[:id])
    @admit.faculty_rankings.build
    @faculty = Faculty.all.sort! {|x, y| x.last_name <=> y.last_name}
  end

  # PUT /people/admits/1
  def update
    @admit = Admit.find(params[:id])
    @faculty = Faculty.all.sort! {|x, y| x.last_name <=> y.last_name}

    if @admit.update_attributes(params[:admit])
      redirect_to(:back, :notice => "Admit was successfully updated.")
    else
      render :action => get_referrer_action
    end
  end

  private
  def set_model
    @model = Admit
  end
end
