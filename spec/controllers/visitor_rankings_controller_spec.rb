require 'spec_helper'

describe VisitorRankingsController do
  before(:each) do
    @visitor = Factory.create(:visitor)
    @fac = Factory.create(:person, :ldap_id => 'fac', :role => 'facilitator')
    RubyCAS::Filter.fake('fac')
    @event = @visitor.event
    Event.stub(:find).and_return(@event)
  end

  describe 'forced profile verification' do
    before(:each) do
      @event.stub_chain(:visitors, :find).and_return(@visitor)
    end

    context 'when an unverified Visitor is signed in' do
      before(:each) do
        @visitor.update_attribute(:verified, false)
        Person.stub(:find_by_ldap_id).and_return(@visitor.person)
      end

      it 'saves the requested URL before redirecting' do
        get :index, :visitor_id => @visitor.id, :event_id => @event.id
        session[:after_verify_url].should == event_visitor_rankings_url(@event)
      end

      it 'redirects when indexing rankings' do
        get :index, :visitor_id => @visitor.id, :event_id => @event.id
        response.should redirect_to(:controller => 'visitors', :action => 'edit', :event_id => @event.id, :id => @visitor.id)
      end

      it 'redirects when adding rankings' do
        get :add, :visitor_id => @visitor.id, :event_id => @event.id
        response.should redirect_to(:controller => 'visitors', :action => 'edit', :event_id => @event.id, :id => @visitor.id)
      end

      it 'redirects when editing rankings' do
        get :edit_all, :visitor_id => @visitor.id, :event_id => @event.id
        response.should redirect_to(:controller => 'visitors', :action => 'edit', :event_id => @event.id, :id => @visitor.id)
      end

      it 'redirects when updating rankings' do
        put :update_all, :visitor_id => @visitor.id, :event_id => @event.id
        response.should redirect_to(:controller => 'visitors', :action => 'edit', :event_id => @event.id, :id => @visitor.id)
      end
    end

    context 'when the signed in person is not an unverified Host' do
      before(:each) do
        Person.stub(:find_by_ldap_id).and_return(Factory.create(:person, :role => 'administrator', :ldap_id => 'administrator'))
        RubyCAS::Filter.fake('administrator')
      end

      it 'does not redirect when indexing rankings' do
        get :index, :visitor_id => @visitor.id, :event_id => @event.id
        response.should render_template('index')
      end

      it 'does not redirect when adding rankings' do
        get :add, :visitor_id => @visitor.id, :event_id => @event.id
        response.should render_template('add')
      end

      it 'does not redirect when editing rankings' do
        get :edit_all, :visitor_id => @visitor.id, :event_id => @event.id
        response.should redirect_to(:action => 'add', :visitor_id => @visitor.id, :event_id => @event.id)
      end

      it 'does not redirect when updating rankings' do
        @visitor.stub(:update_attributes).and_return(false)
        @visitor.stub(:errors).and_return(:error => '')
        put :update_all, :visitor_id => @visitor.id, :event_id => @event.id
        response.should render_template('edit_all')
      end
    end
  end

  describe 'GET index' do
    it 'assigns to @event the given Event' do
      get :index, :visitor_id => @visitor.id, :event_id => @event.id
      assigns[:event].should == @event
    end

    it 'assigns to @ranker the Visitor' do
      Visitor.stub(:find).and_return(@visitor)
      get :index, :visitor_id => @visitor.id, :event_id => @event.id
      assigns[:ranker].should == @visitor
    end

    it 'renders the index template' do
      get :index, :visitor_id => @visitor.id, :event_id => @event.id
      response.should render_template('index')
    end
  end

  describe 'GET add' do
    it 'assigns to @event the given Event' do
      get :add, :visitor_id => @visitor.id, :event_id => @event.id
      assigns[:event].should == @event
    end

    it 'assigns to @ranker the Visitor' do
      @event.stub_chain(:visitors, :find).and_return(@visitor)
      get :add, :visitor_id => @visitor.id, :event_id => @event.id
      assigns[:ranker].should == @visitor
    end

    it 'assigns to @rankables a list of Hosts' do
      rankables = Array.new(3) {Factory.create(:host)}
      @event.stub(:hosts).and_return(rankables)
      get :add, :visitor_id => @visitor.id, :event_id => @event.id
      assigns[:rankables].should == rankables
    end

    it 'renders the add template' do
      get :add, :visitor_id => @visitor.id, :event_id => @event.id
      response.should render_template('add')
    end
  end

  describe 'GET edit_all' do
    it 'assigns to @event the given Event' do
      get :edit_all, :visitor_id => @visitor.id, :event_id => @event.id
      assigns[:event].should == @event
    end

    it 'assigns to @ranker the Visitor' do
      Visitor.stub(:find).and_return(@visitor)
      get :edit_all, :visitor_id => @visitor.id, :event_id => @event.id
      assigns[:ranker].should == @visitor
    end

    context 'when the Visitor has no ranked or selected Hosts' do
      it 'redirects to the Add Rankings Page' do
        get :edit_all, :visitor_id => @visitor.id, :event_id => @event.id
        response.should redirect_to(:controller => 'visitor_rankings', :action => 'add', :visitor_id => @visitor.id)
      end
    end

    context 'when the Visitor has ranked some Hosts' do
      before(:each) do
        Factory.create(:visitor_ranking, :ranker => @visitor)
      end

      it 'does not redirect to the Add Rankings Page' do
        get :edit_all, :visitor_id => @visitor.id, :event_id => @event.id
        response.should_not redirect_to(:controller => 'visitor_rankings', :action => 'add', :visitor_id => @visitor.id)
      end

      it 'renders the edit_all template' do
        get :edit_all, :visitor_id => @visitor.id, :event_id => @event.id
        response.should render_template('edit_all')
      end
    end

    context 'when the Visitor has selected new Hosts to rank' do
      before(:each) do
        @hosts = Array.new(3) {Host.new}
        @event.stub_chain(:hosts, :find).and_return(@hosts)
      end

      it 'finds the given Hosts' do
        @event.hosts.should_receive(:find).with(['1', '2', '3']).and_return(@hosts)
        get :edit_all, :visitor_id => @visitor.id, :event_id => @event.id, :select => {'1' => '1', '2' => '1', '3' => '1', '4' => '0'}
      end

      it 'builds a new VisitorRanking for each given Host' do
        @event.stub_chain(:visitors, :find).and_return(@visitor)
        get :edit_all, :visitor_id => @visitor.id, :event_id => @event.id, :select => {'1' => '1', '2' => '1', '3' => '1', '4' => '0'}
        @visitor.rankings.map(&:rankable).should == @hosts
      end

      it 'does not redirect to the Add Rankings Page' do
        get :edit_all, :visitor_id => @visitor.id, :event_id => @event.id, :select => {'1' => '1', '2' => '1', '3' => '1', '4' => '0'}
        response.should_not redirect_to(:controller => 'visitor_rankings', :action => 'add', :visitor_id => @visitor.id)
      end

      it 'renders the edit_all template' do
        get :edit_all, :visitor_id => @visitor.id, :event_id => @event.id, :select => {'1' => '1', '2' => '1', '3' => '1', '4' => '0'}
        response.should render_template('edit_all')
      end
    end
  end

  describe 'PUT update_all' do
    before(:each) do
      @event.stub_chain(:visitors, :find).and_return(@visitor)
    end

    it 'assigns to @ranker the Visitor' do
      put :update_all, :visitor_id => @visitor.id, :event_id => @event.id
      assigns[:ranker].should == @visitor
    end

    it 'updates the Visitor' do
      @visitor.should_receive(:update_attributes).with('foo' => 'bar')
      put :update_all, :visitor_id => @visitor.id, :event_id => @event.id, :visitor => {'foo' => 'bar'}
    end

    context 'when the Visitor is successfully updated' do
      before(:each) do
        @visitor.stub(:update_attributes).and_return(true)
      end

      it 'sets a flash[:notice] message' do
        put :update_all, :visitor_id => @visitor.id, :event_id => @event.id, :visitor => {'foo' => 'bar'}
        flash[:notice].should == I18n.t('visitors.update.success')
      end

      it 'redirects to the Edit All Rankings Page' do
        put :update_all, :visitor_id => @visitor.id, :event_id => @event.id, :visitor => {'foo' => 'bar'}
        response.should redirect_to(:controller => 'visitor_rankings', :action => 'edit_all', :visitor_id => @visitor.id)
      end
    end

    context 'the Visitor fails to be saved' do
      before(:each) do
        @visitor.stub(:update_attributes).and_return(false)
        @visitor.stub(:errors).and_return(:error => '')
      end

      it 'assigns to @event the given Event' do
        put :update_all, :visitor_id => @visitor.id, :event_id => @event.id, :visitor => {'foo' => 'bar'}
        assigns[:event].should == @event
      end

      it 'renders the Edit All Rankings Page' do
        put :update_all, :visitor_id => @visitor.id, :event_id => @event.id, :visitor => {'foo' => 'bar'}
        response.should render_template('edit_all')
      end
    end
  end
end
