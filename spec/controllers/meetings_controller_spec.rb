require 'spec_helper'

describe MeetingsController do
  before(:each) do
    @event = Factory.create(:event)
    @admin = Factory.create(:person, :ldap_id => 'admin', :role => 'administrator')
    CASClient::Frameworks::Rails::Filter.fake('admin')
  end
  describe "generating the schedule" do
    context "for staff users" do
      it "should be allowed" do
        Meeting.should_receive(:generate)
        post :create_all, :event_id => @event.id
      end
      it "should show the master schedule when done" do
        Meeting.stub!(:generate).and_return(true)
        post :create_all, :event_id => @event.id
        response.should redirect_to(event_meetings_path(:event_id => @event.id))
      end
    end
  end
  describe 'viewing meeting statistics' do
    context 'when signed in as a Staff' do
      it 'assigns to @unsatisfied_visitors a list of unsatisfied Admits' do
        pending
        @event.stub(:unsatisfied_admit_threshold).and_return(3)
        visitor1 = Visitor.new(:event => @event)
        visitor1.meetings.stub(:count).and_return(2)
        visitor2 = Visitor.new(:event => @event)
        visitor2.meetings.stub(:count).and_return(3)
        visitor3 = Visitor.new(:event => @event)
        visitor3.meetings.stub(:count).and_return(4)
        Visitor.stub(:find).and_return([visitor1, visitor2, visitor3])
        get :statistics, :event_id => @event.id
        assigns[:unsatisfied_visitors].should == [visitor1]
      end
      it 'assigns to @unsatisfied_host a list of Faculty with unfulfilled mandatory meetings' do
        pending
        host1 = Factory.create(:host, :event => @event)
        visitor1 = Factory.create(:visitor, :event => @event)
        Factory.create(:host_ranking, :rankable => visitor1, :mandatory => true, :ranker => host1)
        host2 = Factory.create(:host, :event => @event)
        visitor2 = Factory.create(:visitor, :event => @event)
        Factory.create(:host_ranking, :rankable => visitor2, :mandatory => false, :ranker => host2)
        Host.stub(:find).and_return([host1, host2])
        get :statistics, :event_id => @event.id
        assigns[:unsatisfied_hosts].should == [[host1, [visitor1]]]
      end
      it 'assigns to @visitors_with_unsatisfied_rankings a list of visitors with unsatisfied host rankings' do
        pending
        visitor1 = Factory.create(:visitor, :event => @event)
        visitor2 = Factory.create(:visitor, :event => @event)
        host21 = Factory.create(:host, :event => @event)
        ranking21 = Factory.create(:visitor_ranking, :ranker => visitor2, :rankable => host21)
        time_slot = Factory.create(:time_slot, :event => @event)
        host21_availability = host21.availabilities.create(:time_slot => time_slot, :available => true)
        visitor2_availability = visitor2.availabilities.create(:time_slot => time_slot, :available => true)
        Meeting.create(:host_availability => host21_availability, :visitor_availability => visitor2_availability)
        visitor3 = Factory.create(:visitor, :event => @event)
        host31 = Factory.create(:host, :event => @event)
        ranking31 = Factory.create(:visitor_ranking, :ranker => visitor3, :rankable => host31)
        Visitor.stub(:find).and_return([visitor1, visitor2, visitor3])
        [visitor1, visitor2, visitor3].each {|a| a.save; a.rankings.reload}
        get :statistics, :event_id => @event.id
        assigns[:visitors_with_unsatisfied_rankings].should == [[visitor3, [ranking31]]]
      end
      it 'assigns to @host_with_unsatisfied_rankings a list of host with unsatisfied visitor rankings' do
        pending
        time = Time.zone.now
        host1 = Factory.create(:host, :event => @event)
        host2 = Factory.create(:host, :event => @event)
        visitor21 = Factory.create(:visitor, :event => @event)
        Factory.create(:host_ranking, :ranker => host2, :rankable => visitor21)
        time_slot = Factory.create(:time_slot, :event => @event)
        meeting = Meeting.create(
          :host_availability => host2.availabilities.create(:time_slot => time_slot, :available => true),
          :visitor_availability => visitor21.availabilities.create(:time_slot => time_slot, :available => true)
        )
        host3 = Factory.create(:host, :event => @event)
        visitor31 = Factory.create(:visitor, :event => @event)
        ranking31 = Factory.create(:host_ranking, :ranker => host3, :rankable => visitor31)
        Host.stub(:find).and_return([host1, host2, host3])
        [host1, host2, host3].each do |f|
          f.rankings.reload
          f.meetings.reload
        end
        get :statistics, :event_id => @event.id
        assigns[:hosts_with_unsatisfied_rankings].should == [[host3, [ranking31]]]
      end
      it 'renders the statistics template' do
        pending
        get :statistics, :event_id => @event.id
        response.should render_template('statistics')
      end
    end
  end
  describe 'tweaking host schedule' do
    it 'should be allowed for staff' do
      Host.stub!(:find).and_return(Factory.create(:host, :event => @event))
      get :tweak, :host_id => 1, :event_id => @event.id
      response.should render_template(:tweak)
    end
  end
  context "when logged in as any valid user" do
    # For peer advisors
    describe "index" do
      it "should list meetings for host if given host_id" do
        controller.should_receive(:for_faculty).with('3')
        get :index, :host_id => '3', :event_id => @event.id
      end
      it "should list meetings for visitor if given visitor_id" do
        controller.should_receive(:for_admit).with('2')
        get :index, :visitor_id => '2', :event_id => @event.id
      end
      it "should show master schedule if neither host_id nor visitor_id given" do
        controller.should_receive(:master)
        get :index, :event_id => @event.id
      end
    end
  end
end
