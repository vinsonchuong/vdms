require 'spec_helper'

describe HostRankingsController do
  before(:each) do
    @host = Factory.create(:host)
    @host.person.update_attribute(:ldap_id, 'host')
    CASClient::Frameworks::Rails::Filter.fake('host')
  end

  describe 'GET index' do
    it 'assigns to @ranker the Host' do
      Host.stub(:find).and_return(@host)
      get :index, :host_id => @host.id, :event_id => @host.event.id
      assigns[:ranker].should == @host
    end

    it 'renders the index template' do
      get :index, :host_id => @host.id, :event_id => @host.event.id
      response.should render_template('index')
    end
  end

  describe 'GET add' do
    it 'assigns to @ranker the Host' do
      Host.stub(:find).and_return(@host)
      get :add, :host_id => @host.id, :event_id => @host.event.id
      assigns[:ranker].should == @host
    end

    context 'when given no filter' do
      it 'assigns to @areas a list of the Areas, all selected' do
        Person.stub(:areas).and_return('a1' => 'Area 1', 'a2' => 'Area 2', 'a3' => 'Area 3')
        get :add, :host_id => @host.id, :event_id => @host.event.id
        assigns[:areas].should == [['a1', true], ['a2', true], ['a3', true]]
      end

      it 'assigns to @rankables a list of Visitors' do
        rankables = Array.new(3) {Factory.create(:visitor)}
        Visitor.stub(:find).and_return(rankables)
        get :add, :host_id => @host.id, :event_id => @host.event.id
        assigns[:rankables].should == rankables
      end
    end

    context 'when given a filter' do
      it 'assigns to @areas a list areas with their selected state' do
        get :add, :host_id => @host.id, :event_id => @host.event.id, :filter => {'a1' => '1', 'a2' => '0', 'a3' => '1'}
        assigns[:areas].should == [['a1', true], ['a2', false], ['a3', true]]
      end

      it 'assigns to @rankables a list of Visitors in the selected Areas' do
        visitors = Array.new(3) {Visitor.new}
        Visitor.should_receive(:with_areas).with('a1', 'a3').and_return(visitors)
        get :add, :host_id => @host.id, :event_id => @host.event.id, :filter => {'a1' => '1', 'a2' => '0', 'a3' => '1'}
        assigns[:rankables].should == visitors
      end
    end

    it 'removes the currently ranked Visitors from @rankables' do
      ranked_visitor = Visitor.new
      @host.rankings.build(:rankable => ranked_visitor)
      unranked_visitors = Array.new(3) {Visitor.new}
      Visitor.stub(:with_areas).and_return(unranked_visitors + [ranked_visitor])
      Host.stub(:find).and_return(@host)
      get :add, :host_id => @host.id, :event_id => @host.event.id, :filter => {'a1' => '1', 'a2' => '0', 'a3' => '1'}
      assigns[:rankables].should == unranked_visitors
    end

    it 'renders the add template' do
      get :add, :host_id => @host.id, :event_id => @host.event.id
      response.should render_template('add')
    end
  end

  describe 'GET edit_all' do
    it 'assigns to @ranker the Host' do
      Host.stub(:find).and_return(@host)
      get :edit_all, :host_id => @host.id, :event_id => @host.event.id
      assigns[:ranker].should == @host
    end

    context 'when the Host has no ranked or selected Visitors' do
      it 'redirects to the Add Rankings Page' do
        get :edit_all, :host_id => @host.id, :event_id => @host.event.id
        response.should redirect_to(:controller => 'host_rankings', :action => 'add', :host_id => @host.id)
      end
    end

    context 'when the Host has ranked some Visitors' do
      before(:each) do
        Factory.create(:host_ranking, :ranker => @host)
      end

      it 'does not redirect to the Add Rankings Page' do
        get :edit_all, :host_id => @host.id, :event_id => @host.event.id
        response.should_not redirect_to(:controller => 'host_rankings', :action => 'add', :host_id => @host.id)
      end

      it 'renders the edit_all template' do
        get :edit_all, :host_id => @host.id, :event_id => @host.event.id
        response.should render_template('edit_all')
      end
    end

    context 'when the Host has selected new Visitors to rank' do
      before(:each) do
        @visitors = Array.new(3) {Visitor.new}
        Visitor.stub(:find).and_return(@visitors)
      end

      it 'finds the given Visitors' do
        Visitor.should_receive(:find).with(['1', '2', '3']).and_return(@visitors)
        get :edit_all, :host_id => @host.id, :event_id => @host.event.id, :select => {'1' => '1', '2' => '1', '3' => '1', '4' => '0'}
      end

      it 'builds a new HostRanking for each given Visitor' do
        Host.stub(:find).and_return(@host)
        get :edit_all, :host_id => @host.id, :event_id => @host.event.id, :select => {'1' => '1', '2' => '1', '3' => '1', '4' => '0'}
        @host.rankings.map(&:rankable).should == @visitors
      end

      it 'does not redirect to the Add Rankings Page' do
        get :edit_all, :host_id => @host.id, :event_id => @host.event.id, :select => {'1' => '1', '2' => '1', '3' => '1', '4' => '0'}
        response.should_not redirect_to(:controller => 'host_rankings', :action => 'add', :host_id => @host.id)
      end

      it 'renders the edit_all template' do
        get :edit_all, :host_id => @host.id, :event_id => @host.event.id, :select => {'1' => '1', '2' => '1', '3' => '1', '4' => '0'}
        response.should render_template('edit_all')
      end
    end
  end

  describe 'PUT update_all' do
    before(:each) do
      Host.stub(:find).and_return(@host)
    end

    it 'assigns to @ranker the Host' do
      put :update_all, :host_id => @host.id, :event_id => @host.event.id
      assigns[:ranker].should == @host
    end

    it 'updates the Host' do
      @host.should_receive(:update_attributes).with('foo' => 'bar')
      put :update_all, :host_id => @host.id, :event_id => @host.event.id, :host => {'foo' => 'bar'}
    end

    context 'when the Host is successfully updated' do
      before(:each) do
        @host.stub(:update_attributes).and_return(true)
      end

      it 'sets a flash[:notice] message' do
        put :update_all, :host_id => @host.id, :event_id => @host.event.id, :host => {'foo' => 'bar'}
        flash[:notice].should == I18n.t('hosts.update.success')
      end

      it 'redirects to the Edit All Rankings Page' do
        put :update_all, :host_id => @host.id, :event_id => @host.event.id, :host => {'foo' => 'bar'}
        response.should redirect_to(:controller => 'host_rankings', :action => 'edit_all', :host_id => @host.id)
      end
    end

    context 'the Host fails to be saved' do
      before(:each) do
        @host.stub(:update_attributes).and_return(false)
      end

      it 'renders the Edit All Rankings Page' do
        put :update_all, :host_id => @host.id, :event_id => @host.event.id, :host => {'foo' => 'bar'}
        response.should render_template('edit_all')
      end
    end
  end
end
