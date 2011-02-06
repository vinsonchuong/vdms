class AdmitsController < PeopleController
  # GET /people/PEOPLE/admits_filter_by_area_of_interests
  def filter_by_area_of_interests
    @admits = []
    list_of_admit_ids_from_rankings = Faculty.find(params[:faculty_id]).admit_rankings.collect {|admit_ranking| admit_ranking.admit_id}
    if params[:area_of_interests]
      params[:area_of_interests].each do |area|
        Admit.find(:all, :conditions => ["area1 = ? OR area2 = ?", area, area]).each {|admit| @admits = @admits + [admit] if !(list_of_admit_ids_from_rankings.member? admit.id)}  
      end
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
      redirect_to(:back, :notice => "Admit was successfully updated")
    else
      render :action => get_referrer_action
    end
  end

  private
  def set_model
    @model = Admit
  end
end
