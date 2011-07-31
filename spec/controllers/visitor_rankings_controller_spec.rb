require 'spec_helper'

describe VisitorRankingsController do
  before(:each) do
    @visitor = Factory.create(:visitor)
    @staff = Factory.create(:staff)
    CASClient::Frameworks::Rails::Filter.fake(@staff.ldap_id)
    Staff.stub(:find).and_return(@staff)
  end

  describe 'GET index' do
    it 'assigns to @ranker the Visitor' do
      Visitor.stub(:find).and_return(@visitor)
      get :index, :visitor_id => @visitor.id
      assigns[:ranker].should == @visitor
    end

    it 'renders the index template' do
      get :index, :visitor_id => @visitor.id
      response.should render_template('index')
    end
  end

  describe 'GET add' do
    it 'assigns to @ranker the Visitor' do
      Visitor.stub(:find).and_return(@visitor)
      get :add, :visitor_id => @visitor.id
      assigns[:ranker].should == @visitor
    end

    it 'assigns to @rankables a list of Hosts' do
      rankables = Array.new(3) {Factory.create(:host)}
      Host.stub(:find).and_return(rankables)
      get :add, :visitor_id => @visitor.id
      assigns[:rankables].should == rankables
    end

    it 'renders the add template' do
      get :add, :visitor_id => @visitor.id
      response.should render_template('add')
    end
  end

  describe 'GET edit_all' do
    it 'assigns to @ranker the Visitor' do
      Visitor.stub(:find).and_return(@visitor)
      get :edit_all, :visitor_id => @visitor.id
      assigns[:ranker].should == @visitor
    end

    context 'when the Visitor has no ranked or selected Hosts' do
      it 'redirects to the Add Rankings Page' do
        get :edit_all, :visitor_id => @visitor.id
        response.should redirect_to(:controller => 'visitor_rankings', :action => 'add', :visitor_id => @visitor.id)
      end
    end

    context 'when the Visitor has ranked some Hosts' do
      before(:each) do
        Factory.create(:visitor_ranking, :ranker => @visitor)
      end

      it 'does not redirect to the Add Rankings Page' do
        get :edit_all, :visitor_id => @visitor.id
        response.should_not redirect_to(:controller => 'visitor_rankings', :action => 'add', :visitor_id => @visitor.id)
      end

      it 'renders the edit_all template' do
        get :edit_all, :visitor_id => @visitor.id
        response.should render_template('edit_all')
      end
    end

    context 'when the Visitor has selected new Hosts to rank' do
      before(:each) do
        @hosts = Array.new(3) {Host.new}
        Host.stub(:find).and_return(@hosts)
      end

      it 'finds the given Hosts' do
        Host.should_receive(:find).with(['1', '2', '3']).and_return(@hosts)
        get :edit_all, :visitor_id => @visitor.id, :select => {'1' => '1', '2' => '1', '3' => '1', '4' => '0'}
      end

      it 'builds a new VisitorRanking for each given Host' do
        Visitor.stub(:find).and_return(@visitor)
        get :edit_all, :visitor_id => @visitor.id, :select => {'1' => '1', '2' => '1', '3' => '1', '4' => '0'}
        @visitor.rankings.map(&:rankable).should == @hosts
      end

      it 'does not redirect to the Add Rankings Page' do
        get :edit_all, :visitor_id => @visitor.id, :select => {'1' => '1', '2' => '1', '3' => '1', '4' => '0'}
        response.should_not redirect_to(:controller => 'visitor_rankings', :action => 'add', :visitor_id => @visitor.id)
      end

      it 'renders the edit_all template' do
        get :edit_all, :visitor_id => @visitor.id, :select => {'1' => '1', '2' => '1', '3' => '1', '4' => '0'}
        response.should render_template('edit_all')
      end
    end
  end

  describe 'PUT update_all' do
    before(:each) do
      Visitor.stub(:find).and_return(@visitor)
    end

    it 'assigns to @ranker the Visitor' do
      put :update_all, :visitor_id => @visitor.id
      assigns[:ranker].should == @visitor
    end

    it 'updates the Visitor' do
      @visitor.should_receive(:update_attributes).with('foo' => 'bar')
      put :update_all, :visitor_id => @visitor.id, :visitor => {'foo' => 'bar'}
    end

    context 'when the Visitor is successfully updated' do
      before(:each) do
        @visitor.stub(:update_attributes).and_return(true)
      end

      it 'sets a flash[:notice] message' do
        put :update_all, :visitor_id => @visitor.id, :visitor => {'foo' => 'bar'}
        flash[:notice].should == I18n.t('visitors.update.success')
      end

      it 'redirects to the Edit All Rankings Page' do
        put :update_all, :visitor_id => @visitor.id, :visitor => {'foo' => 'bar'}
        response.should redirect_to(:controller => 'visitor_rankings', :action => 'edit_all', :visitor_id => @visitor.id)
      end
    end

    context 'the Visitor fails to be saved' do
      before(:each) do
        @visitor.stub(:update_attributes).and_return(false)
      end

      it 'renders the Edit All Rankings Page' do
        put :update_all, :visitor_id => @visitor.id, :visitor => {'foo' => 'bar'}
        response.should render_template('edit_all')
      end
    end
  end
end
