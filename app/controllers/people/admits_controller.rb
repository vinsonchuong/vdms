class AdmitsController < PeopleController
  
  # # GET /people/PEOPLE/admits_filter_by_area_of_interests
  def filter_by_area_of_interests
    @admits = []
    list_of_admit_ids_from_rankings = Faculty.find(params[:faculty_id]).admit_rankings.collect {|admit_ranking| admit_ranking.admit_id}
    if params[:area_of_interests]
      params[:area_of_interests].each do |area|
        admits = Admit.find(:all, :conditions => ["area1 = ? OR area2 = ?", area, area])
        admits.each {|admit| @admits = @admits + [admit] if !(list_of_admit_ids_from_rankings.member? admit.id)}  
      end
      @admits.uniq!
    end
  end
    
  private
  def set_model
    @model = Admit
  end
end
