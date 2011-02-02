class AdmitsController < PeopleController
  
  # # GET /people/PEOPLE/admits_filter_by_area_of_interests
  def filter_by_area_of_interests
    @admits = []
    faculty = Faculty.find(params[:faculty_id])
    params.each do |area_key, area_value|
      @admit = Admit.find(:all, :conditions => ["area1 = ? OR area2 = ?", area_value, area_value])
      @admits = @admits + @admit #if faculty.admit_rankings.find(:all, :conditions => ["admit_id != ?", @admit.id])
      #Admit.find(:all, :conditions => ["area1 = ? OR area2 = ?", area_value, area_value])
      # @admit #if faculty.admit_rankings.find(:all, :conditions => ["admit_id != ?", @admit.id])
    end
    @admits.uniq!
  end
    
  private
  def set_model
    @model = Admit
  end
end
