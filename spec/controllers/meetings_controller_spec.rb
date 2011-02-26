require 'spec_helper'

describe MeetingsController do
  describe "generating the schedule" do
    it "should be forbidden for Faculty users" do
      CASClient::Frameworks::Rails::Filter.fake(Factory.create(:faculty).ldap_id)
      Meeting.should_not_receive(:generate)
      post :create_all
      response.should redirect_to(home_path)
    end
    it "should be forbidden for Peer Advisor users" do
      CASClient::Frameworks::Rails::Filter.fake(Factory.create(:peer_advisor).ldap_id)
      Meeting.should_not_receive(:generate)
      post :create_all
      response.should redirect_to(home_path)
    end
    context "for staff users" do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(Factory.create(:staff).ldap_id)
      end
      it "should be allowed" do
        Meeting.should_receive(:generate)
        post :create_all
      end
      it "should show the master schedule when done" do
        Meeting.stub!(:generate).and_return(true)
        post :create_all
        response.should redirect_to(master_meetings_path)
      end
    end
  end
  context "when logged in as any valid user" do
    before(:each) do
      @current_user = Factory.create(:peer_advisor)
      CASClient::Frameworks::Rails::Filter.fake(@current_user.ldap_id)
    end
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
    describe "master schedule" do
      before(:each) do
        @nine_am = Time.parse("9:00am")
        @ten_am = Time.parse("10:00am")
        @all_meetings = [
          @m1 = mock('meeting1', :faculty => 3, :time => @nine_am),
          @m2 = mock('meeting2', :faculty => 3, :time => @ten_am),
          @m3 = mock('meeting3', :faculty => 2, :time => @ten_am)
        ]
        Meeting.stub!(:all).and_return(@all_meetings)
      end
      it "should include all meetings sorted by faculty" do
        get :master
        sorted = assigns[:meetings_by_faculty]
        sorted.should be_a_kind_of(Hash)
        sorted[3].should include(@m1)
        sorted[3].should include(@m2)
        sorted[2].should include(@m3)
        end
      it "should enumerate the times without duplicates" do
        get :master
        assigns[:times].should == [@nine_am, @ten_am]
      end
    end
  end
end
