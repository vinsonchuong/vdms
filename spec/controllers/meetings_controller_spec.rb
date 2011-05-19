require 'spec_helper'

describe MeetingsController do
  def fake_login(role)
    CASClient::Frameworks::Rails::Filter.fake(Factory.create(role).ldap_id)
  end
  def schedule!(meeting,admits)
    meeting.faculty.stub!(:available_at?).and_return(true)
    meeting.faculty.available_times.create!(:begin => meeting.time, :end => meeting.time+60)
    meeting.faculty.max_admits_per_meeting = admits.length
    meeting.admits = admits
    admits.each { |admit|  admit.stub!(:available_at?).and_return(true) }
    meeting.faculty.save!
    meeting.save!
  end
  describe "generating the schedule" do
    it "should be forbidden for Faculty users" do
      fake_login(:faculty)
      Meeting.should_not_receive(:generate)
      post :create_all
      response.should redirect_to(home_path)
    end
    it "should be forbidden for Peer Advisor users" do
      fake_login(:peer_advisor)
      Meeting.should_not_receive(:generate)
      post :create_all
      response.should redirect_to(home_path)
    end
    context "for staff users" do
      before(:each) { fake_login(:staff) }
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
  describe 'viewing meeting statistics' do
    context 'when signed in as a Staff' do
      before(:each) do
        @settings = Settings.instance
        Settings.stub(:instance).and_return(@settings)
        @staff = Factory.create(:staff)
        CASClient::Frameworks::Rails::Filter.fake(@staff.ldap_id)
      end
      it 'assigns to @unsatisfied_admits a list of unsatisfied Admits' do
        @settings.stub(:unsatisfied_admit_threshold).and_return(3)
        admit1 = Admit.new
        admit1.meetings.stub(:count).and_return(2)
        admit2 = Admit.new
        admit2.meetings.stub(:count).and_return(3)
        admit3 = Admit.new
        admit3.meetings.stub(:count).and_return(4)
        Admit.stub(:find).and_return([admit1, admit2, admit3])
        get :statistics
        assigns[:unsatisfied_admits].should == [admit1]
      end
      it 'assigns to @unsatisfied_faculty a list of Faculty with unfulfilled mandatory meetings' do
        faculty1 = Factory.create(:faculty)
        admit1 = Factory.create(:admit)
        Factory.create(:admit_ranking, :admit => admit1, :mandatory => true, :faculty => faculty1)
        faculty2 = Factory.create(:faculty)
        admit2 = Factory.create(:admit)
        Factory.create(:admit_ranking, :admit => admit2, :mandatory => false, :faculty => faculty2)
        Faculty.stub(:find).and_return([faculty1, faculty2])
        get :statistics
        assigns[:unsatisfied_faculty].should == [[faculty1, [admit1]]]
      end
      it 'assigns to @admits_with_unsatisfied_rankings a list of admits with unsatisfied faculty rankings' do
        admit1 = Factory.create(:admit)
        admit2 = Factory.create(:admit)
        faculty21 = Factory.create(:faculty)
        ranking21 = Factory.create(:faculty_ranking, :admit => admit2, :faculty => faculty21)
        Factory.create(:meeting, :faculty => faculty21).admits << admit2
        admit3 = Factory.create(:admit)
        faculty31 = Factory.create(:faculty)
        ranking31 = Factory.create(:faculty_ranking, :admit => admit3, :faculty => faculty31)
        Admit.stub(:find).and_return([admit1, admit2, admit3])
        [admit1, admit2, admit3].each {|a| a.save; a.faculty_rankings.reload}
        get :statistics
        assigns[:admits_with_unsatisfied_rankings].should == [[admit3, [ranking31]]]
      end
      it 'assigns to @faculty_with_unsatisfied_rankings a list of faculty with unsatisfied admit rankings' do
        time = Time.zone.now
        faculty1 = Factory.create(:faculty)
        faculty2 = Factory.create(:faculty)
        admit21 = Factory.create(:admit)
        admit21.available_times.create(:begin => time, :end => time + 20.minutes, :available => true)
        Factory.create(:admit_ranking, :faculty => faculty2, :admit => admit21)
        faculty2.available_times.create(:begin => time, :end => time + 20.minutes, :available => true)
        meeting = Factory.create(:meeting, :time => time, :faculty => faculty2)
        meeting.add_admit!(admit21)
        faculty3 = Factory.create(:faculty)
        admit31 = Factory.create(:admit)
        ranking31 = Factory.create(:admit_ranking, :faculty => faculty3, :admit => admit31)
        Faculty.stub(:find).and_return([faculty1, faculty2, faculty3])
        [faculty1, faculty2, faculty3].each do |f|
          f.admit_rankings.reload
          f.meetings.reload
        end
        get :statistics
        assigns[:faculty_with_unsatisfied_rankings].should == [[faculty3, [ranking31]]]
      end
      it 'renders the statistics template' do
        get :statistics
        response.should render_template('statistics')
      end
    end
  end
  describe 'tweaking faculty schedule' do
    it 'should be allowed for staff' do
      fake_login(:staff)
      Faculty.stub!(:find).and_return(Factory.create(:faculty))
      get :tweak, :faculty_id => 1
      response.should render_template(:tweak)
    end
    it 'should be forbidden for peer advisors' do
      fake_login(:peer_advisor)
      get :tweak, :faculty_id => 1
      response.should redirect_to(home_path)
      flash[:alert].should == 'Only Staff users may perform this action.'
    end
    it 'should be forbidden for faculty' do
      fake_login(:faculty)
      get :tweak, :faculty_id => 1
      response.should redirect_to(home_path)
      flash[:alert].should == 'Only Staff users may perform this action.'
    end
  end
  describe 'manually deleting' do
    before(:each) do
      fake_login(:staff)
    end
    it 'should delete the meeting' do
      admit1 = Factory.create(:admit)
      admit2 = Factory.create(:admit)
      meeting = Factory.create(:meeting)
      schedule!(meeting, [admit1, admit2])
      params  = {:faculty_id => 1, "remove_#{admit1.id}_#{meeting.id}" => '1'}
      post :apply_tweaks, params
      meeting.admits.reload.should_not include(admit1)
    end
  end
  context "when logged in as any valid user" do
    before(:each) { fake_login(:peer_advisor) }
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
        @nine_am = Time.zone.parse("9:00am")
        @ten_am = Time.zone.parse("10:00am")
        @faculty1 = Factory.create(:faculty)
        @faculty2 = Factory.create(:faculty)
        @faculty2.available_times.create(:begin => @ten_am, :end => @ten_am + 20.minutes, :available => true)
        @faculty3 = Factory.create(:faculty)
        @faculty3.available_times.create(:begin => @nine_am, :end => @nine_am + 20.minutes, :available => true)
        @faculty3.available_times.create(:begin => @ten_am, :end => @ten_am + 20.minutes, :available => true)
        @m1 = Factory.create(:meeting, :faculty => @faculty3, :time => @nine_am)
        @m2 = Factory.create(:meeting, :faculty => @faculty3, :time => @ten_am)
        @m3 = Factory.create(:meeting, :faculty => @faculty2, :time => @ten_am)
        [@faculty1, @faculty2, @faculty3].each {|f| f.meetings.reload}
      end
      it "should include all meetings sorted by faculty" do
        get :master
        sorted = assigns[:meetings_by_faculty]
        sorted.should be_a_kind_of(Array)
        sorted.detect {|f, m| f == @faculty3}[1].should include(@m1)
        sorted.detect {|f, m| f == @faculty3}[1].should include(@m2)
        sorted.detect {|f, m| f == @faculty2}[1].should include(@m3)
        end
      it "should enumerate the times without duplicates" do
        get :master
        assigns[:times].should == [@nine_am, @ten_am]
      end
    end
  end
end
