require 'spec_helper'

describe HostRankingsController do
  before(:each) do
    @host = Factory.create(:host)
    @host.person.update_attribute(:ldap_id, 'host')
    RubyCAS::Filter.fake('host')
    @event = @host.event
    Event.stub(:find).and_return(@event)
  end

  describe 'forced profile verification' do
    before(:each) do
      @event.stub_chain(:hosts, :find).and_return(@host)
    end

    context 'when an unverified Host is signed in' do
      before(:each) do
        @host.update_attribute(:verified, false)
        Person.stub(:find_by_ldap_id).and_return(@host.person)
      end

      it 'saves the requested URL before redirecting' do
        get :index, :host_id => @host.id, :event_id => @event.id
        session[:after_verify_url].should == event_host_rankings_url(@event)
      end

      it 'redirects when indexing rankings' do
        get :index, :host_id => @host.id, :event_id => @event.id
        response.should redirect_to(:controller => 'hosts', :action => 'edit', :event_id => @event.id, :id => @host.id)
      end

      it 'redirects when adding rankings' do
        get :add, :host_id => @host.id, :event_id => @event.id
        response.should redirect_to(:controller => 'hosts', :action => 'edit', :event_id => @event.id, :id => @host.id)
      end

      it 'redirects when editing rankings' do
        get :edit_all, :host_id => @host.id, :event_id => @event.id
        response.should redirect_to(:controller => 'hosts', :action => 'edit', :event_id => @event.id, :id => @host.id)
      end

      it 'redirects when updating rankings' do
        put :update_all, :host_id => @host.id, :event_id => @event.id
        response.should redirect_to(:controller => 'hosts', :action => 'edit', :event_id => @event.id, :id => @host.id)
      end
    end

    context 'when the signed in person is not an unverified Host' do
      before(:each) do
        Person.stub(:find_by_ldap_id).and_return(Factory.create(:person, :role => 'administrator', :ldap_id => 'administrator'))
        RubyCAS::Filter.fake('administrator')
      end

      it 'does not redirect when indexing rankings' do
        get :index, :host_id => @host.id, :event_id => @event.id
        response.should render_template('index')
      end

      it 'does not redirect when adding rankings' do
        get :add, :host_id => @host.id, :event_id => @event.id
        response.should render_template('add')
      end

      it 'does not redirect when editing rankings' do
        get :edit_all, :host_id => @host.id, :event_id => @event.id
        response.should redirect_to(:action => 'add', :host_id => @host.id, :event_id => @event.id)
      end

      it 'does not redirect when updating rankings' do
        @host.stub(:update_attributes).and_return(false)
        @host.stub(:errors).and_return(:error => '')
        put :update_all, :host_id => @host.id, :event_id => @event.id
        response.should render_template('edit_all')
      end
    end
  end

  describe 'GET index' do
    it 'assigns to @event the Event' do
      get :index, :host_id => @host.id, :event_id => @event.id
      assigns[:event].should == @event
    end

    it 'assigns to @ranker the Host' do
      Host.stub(:find).and_return(@host)
      get :index, :host_id => @host.id, :event_id => @event.id
      assigns[:ranker].should == @host
    end

    it 'renders the index template' do
      get :index, :host_id => @host.id, :event_id => @event.id
      response.should render_template('index')
    end
  end

  describe 'GET add' do
    it 'assigns to @event the Event' do
      get :add, :host_id => @host.id, :event_id => @event.id
      assigns[:event].should == @event
    end

    it 'assigns to @ranker the Host' do
      @event.stub_chain(:hosts, :find).and_return(@host)
      get :add, :host_id => @host.id, :event_id => @event.id
      assigns[:ranker].should == @host
    end

    it 'assigns @rankables a list of unranked Visitors' do
      ranked_visitor = Visitor.new
      @host.rankings.build(:rankable => ranked_visitor)
      unranked_visitors = Array.new(3) {Visitor.new}
      @event.stub(:visitors).and_return(unranked_visitors + [ranked_visitor])
      @event.stub_chain(:hosts, :find).and_return(@host)
      get :add, :host_id => @host.id, :event_id => @event.id
      assigns[:rankables].should == unranked_visitors
    end

    it 'renders the add template' do
      get :add, :host_id => @host.id, :event_id => @event.id
      response.should render_template('add')
    end
  end

  describe 'GET edit_all' do
    it 'assigns to @event the Event' do
      get :edit_all, :host_id => @host.id, :event_id => @event.id
      assigns[:event].should == @event
    end

    it 'assigns to @ranker the Host' do
      @event.stub_chain(:hosts, :find).and_return(@host)
      get :edit_all, :host_id => @host.id, :event_id => @event.id
      assigns[:ranker].should == @host
    end

    context 'when the Host has no ranked or selected Visitors' do
      it 'redirects to the Add Rankings Page' do
        get :edit_all, :host_id => @host.id, :event_id => @event.id
        response.should redirect_to(:controller => 'host_rankings', :action => 'add', :host_id => @host.id)
      end
    end

    context 'when the Host has ranked some Visitors' do
      before(:each) do
        Factory.create(:host_ranking, :ranker => @host)
      end

      it 'does not redirect to the Add Rankings Page' do
        get :edit_all, :host_id => @host.id, :event_id => @event.id
        response.should_not redirect_to(:controller => 'host_rankings', :action => 'add', :host_id => @host.id)
      end

      it 'renders the edit_all template' do
        get :edit_all, :host_id => @host.id, :event_id => @event.id
        response.should render_template('edit_all')
      end
    end

    context 'when the Host has selected new Visitors to rank' do
      before(:each) do
        @visitors = Array.new(3) {Visitor.new}
        @event.stub_chain(:visitors, :find).and_return(@visitors)
      end

      it 'finds the given Visitors' do
        @event.visitors.should_receive(:find).with(['1', '2', '3']).and_return(@visitors)
        get :edit_all, :host_id => @host.id, :event_id => @event.id, :select => {'1' => '1', '2' => '1', '3' => '1', '4' => '0'}
      end

      it 'builds a new HostRanking for each given Visitor' do
        @event.stub_chain(:hosts, :find).and_return(@host)
        get :edit_all, :host_id => @host.id, :event_id => @event.id, :select => {'1' => '1', '2' => '1', '3' => '1', '4' => '0'}
        @host.rankings.map(&:rankable).should == @visitors
      end

      it 'does not redirect to the Add Rankings Page' do
        get :edit_all, :host_id => @host.id, :event_id => @event.id, :select => {'1' => '1', '2' => '1', '3' => '1', '4' => '0'}
        response.should_not redirect_to(:controller => 'host_rankings', :action => 'add', :host_id => @host.id)
      end

      it 'renders the edit_all template' do
        get :edit_all, :host_id => @host.id, :event_id => @event.id, :select => {'1' => '1', '2' => '1', '3' => '1', '4' => '0'}
        response.should render_template('edit_all')
      end
    end
  end

  describe 'PUT update_all' do
    before(:each) do
      @event.stub_chain(:hosts, :find).and_return(@host)
    end

    it 'assigns to @ranker the Host' do
      put :update_all, :host_id => @host.id, :event_id => @event.id
      assigns[:ranker].should == @host
    end

    it 'updates the Host' do
      @host.should_receive(:update_attributes).with('foo' => 'bar')
      put :update_all, :host_id => @host.id, :event_id => @event.id, :host => {'foo' => 'bar'}
    end

    context 'when the Host is successfully updated' do
      before(:each) do
        @host.stub(:update_attributes).and_return(true)
      end

      it 'sets a flash[:notice] message' do
        put :update_all, :host_id => @host.id, :event_id => @event.id, :host => {'foo' => 'bar'}
        flash[:notice].should == I18n.t('hosts.update.success')
      end

      it 'redirects to the Edit All Rankings Page' do
        put :update_all, :host_id => @host.id, :event_id => @event.id, :host => {'foo' => 'bar'}
        response.should redirect_to(:controller => 'host_rankings', :action => 'edit_all', :host_id => @host.id)
      end
    end

    context 'the Host fails to be saved' do
      before(:each) do
        @host.stub(:update_attributes).and_return(false)
        @host.stub(:errors).and_return(:error => '')
      end

      it 'assigns to @event the Event' do
        put :update_all, :host_id => @host.id, :event_id => @event.id, :host => {'foo' => 'bar'}
        assigns[:event].should == @event
      end

      it 'renders the Edit All Rankings Page' do
        put :update_all, :host_id => @host.id, :event_id => @event.id, :host => {'foo' => 'bar'}
        response.should render_template('edit_all')
      end
    end
  end
end
