class AdmitRankingsController < ApplicationController
  
  # GET /people/faculties/:faculty_id/admit_rankings
  def index
    faculty = Faculty.find(params[:faculty_id])
    @admit_rankings = faculty.admit_rankings
  end
  
  # GET /people/faculties/:faculty_id/admit_rankings/new
  def new
    @faculty = Faculty.find(params[:faculty_id])
    params[:admit_ids].each {|admit_id| @faculty.admit_rankings.build(:admit_id => admit_id)} if params[:admit_ids]
  end
 
  def update
  end
  
  
  
end