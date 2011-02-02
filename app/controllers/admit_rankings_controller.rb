class AdmitRankingsController < ApplicationController
  
  # GET /people/faculties/:faculty_id/admit_rankings
  def index
    faculty = Faculty.find(params[:faculty_id])
    @admit_rankings = faculty.admit_rankings
  end
  
  # GET /people/faculties/:faculty_id/admit_rankings/new
  def new
    @faculty = Faculty.find(params[:faculty_id])
    if params[:admit_ids]
      params[:admit_ids].each do |admit_id|  
        @admit_ranking = @faculty.admit_rankings.build(:admit_id => admit_id)
      end
    end
  end
  
end