class MeetingsController < ApplicationController

  # GET /meetings/
  def index  
  end
  
  # GET /meetings/new
  def new 
    Meeting.generate()
  end




end