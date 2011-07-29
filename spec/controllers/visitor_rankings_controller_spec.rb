require 'spec_helper'

describe VisitorRankingsController do
  before(:each) do
    @admit = Factory.create(:admit)
    @staff = Factory.create(:staff)
    CASClient::Frameworks::Rails::Filter.fake(@staff.ldap_id)
    Staff.stub(:find).and_return(@staff)
  end

  describe 'GET index' do
    it 'assigns to @ranker the Visitor' do
      Admit.stub(:find).and_return(@admit)
      get :index, :admit_id => @admit.id
      assigns[:ranker].should == @admit
    end

    it 'renders the index template' do
      get :index, :admit_id => @admit.id
      response.should render_template('index')
    end
  end

  describe 'GET add' do
    it 'assigns to @ranker the Visitor' do
      Admit.stub(:find).and_return(@admit)
      get :add, :admit_id => @admit.id
      assigns[:ranker].should == @admit
    end

    it 'assigns to @rankables a list of Faculty' do
      rankables = Array.new(3) {Factory.create(:faculty)}
      get :add, :admit_id => @admit.id
      assigns[:rankables].should == rankables
    end

    it 'renders the add template' do
      get :add, :admit_id => @admit.id
      response.should render_template('add')
    end
  end

  describe 'GET edit_all' do
    it 'assigns to @ranker the Visitor' do
      Admit.stub(:find).and_return(@admit)
      get :edit_all, :admit_id => @admit.id
      assigns[:ranker].should == @admit
    end

    context 'when the Visitor has no ranked or selected Hosts' do
      it 'redirects to the Add Rankings Page' do
        get :edit_all, :admit_id => @admit.id
        response.should redirect_to(:controller => 'visitor_rankings', :action => 'add', :admit_id => @admit.id)
      end
    end

    context 'when the Visitor has ranked some Hosts' do
      before(:each) do
        Factory.create(:visitor_ranking, :ranker => @admit)
      end

      it 'does not redirect to the Add Rankings Page' do
        get :edit_all, :admit_id => @admit.id
        response.should_not redirect_to(:controller => 'visitor_rankings', :action => 'add', :admit_id => @admit.id)
      end

      it 'renders the edit_all template' do
        get :edit_all, :admit_id => @admit.id
        response.should render_template('edit_all')
      end
    end

    context 'when the Visitor has selected new Hosts to rank' do
      before(:each) do
        @hosts = Array.new(3) {Faculty.new}
        Faculty.stub(:find).and_return(@hosts)
      end

      it 'finds the given Hosts' do
        Faculty.should_receive(:find).with(['1', '2', '3']).and_return(@hosts)
        get :edit_all, :admit_id => @admit.id, :select => {'1' => '1', '2' => '1', '3' => '1', '4' => '0'}
      end

      it 'builds a new VisitorRanking for each given Host' do
        Admit.stub(:find).and_return(@admit)
        get :edit_all, :admit_id => @admit.id, :select => {'1' => '1', '2' => '1', '3' => '1', '4' => '0'}
        @admit.rankings.map(&:rankable).should == @hosts
      end

      it 'does not redirect to the Add Rankings Page' do
        get :edit_all, :admit_id => @admit.id, :select => {'1' => '1', '2' => '1', '3' => '1', '4' => '0'}
        response.should_not redirect_to(:controller => 'visitor_rankings', :action => 'add', :admit_id => @admit.id)
      end

      it 'renders the edit_all template' do
        get :edit_all, :admit_id => @admit.id, :select => {'1' => '1', '2' => '1', '3' => '1', '4' => '0'}
        response.should render_template('edit_all')
      end
    end
  end

  describe 'PUT update_all' do
    before(:each) do
      Admit.stub(:find).and_return(@admit)
    end

    it 'assigns to @ranker the Visitor' do
      put :update_all, :admit_id => @admit.id
      assigns[:ranker].should == @admit
    end

    it 'updates the Visitor' do
      @admit.should_receive(:update_attributes).with('foo' => 'bar')
      put :update_all, :admit_id => @admit.id, :admit => {'foo' => 'bar'}
    end

    context 'when the Visitor is successfully updated' do
      before(:each) do
        @admit.stub(:update_attributes).and_return(true)
      end

      it 'sets a flash[:notice] message' do
        put :update_all, :admit_id => @admit.id, :admit => {'foo' => 'bar'}
        flash[:notice].should == I18n.t('people.admits.update.success')
      end

      it 'redirects to the Edit All Rankings Page' do
        put :update_all, :admit_id => @admit.id, :admit => {'foo' => 'bar'}
        response.should redirect_to(:controller => 'visitor_rankings', :action => 'edit_all', :admit_id => @admit.id)
      end
    end

    context 'the Visitor fails to be saved' do
      before(:each) do
        @admit.stub(:update_attributes).and_return(false)
      end

      it 'renders the Edit All Rankings Page' do
        put :update_all, :admit_id => @admit.id, :admit => {'foo' => 'bar'}
        response.should render_template('edit_all')
      end
    end
  end
end
