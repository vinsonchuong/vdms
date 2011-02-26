require 'spec_helper'

describe MeetingsController do
  describe "index" do
    it "should list meetings for faculty if given faculty_id" do
      controller.should_receive(:for_faculty).with('3')
      get :index, :faculty_id => '3'
    end
    it "should list meetings for admit if given admit_id" do
      controller.should_receive(:for_admit).with('2')
      get :index, :admit_id => '2'
    end
    it "should show master schedule if neither faculty_id nor admit_id given" do
      controller.should_receive(:master)
      get :index
    end
  end

end
