require 'spec_helper'

describe HostRankingsController do
  before(:each) do
    @faculty_instance = Factory.create(:faculty)
    @staff = Factory.create(:staff)
    CASClient::Frameworks::Rails::Filter.fake(@staff.ldap_id)
    Staff.stub(:find).and_return(@staff)
  end

  describe 'GET index' do
    it 'assigns to @ranker the Host' do
      Faculty.stub(:find).and_return(@faculty_instance)
      get :index, :faculty_instance_id => @faculty_instance.id
      assigns[:ranker].should == @faculty_instance
    end

    it 'renders the index template' do
      get :index, :faculty_instance_id => @faculty_instance.id
      response.should render_template('index')
    end
  end

  describe 'GET add' do
    it 'assigns to @ranker the Host' do
      Faculty.stub(:find).and_return(@faculty_instance)
      get :add, :faculty_instance_id => @faculty_instance.id
      assigns[:ranker].should == @faculty_instance
    end

    context 'when given no filter' do
      it 'assigns to @areas a list of the Areas, all selected' do
        stub_areas('a1' => 'Area 1', 'a2' => 'Area 2', 'a3' => 'Area 3')
        get :add, :faculty_instance_id => @faculty_instance.id
        assigns[:areas].should == [['a1', true], ['a2', true], ['a3', true]]
      end

      it 'assigns to @rankables a list of Visitors' do
        rankables = Array.new(3) {Factory.create(:admit)}
        get :add, :faculty_instance_id => @faculty_instance.id
        assigns[:rankables].should == rankables
      end
    end

    context 'when given a filter' do
      it 'assigns to @areas a list areas with their selected state' do
        get :add, :faculty_instance_id => @faculty_instance.id, :filter => {'a1' => '1', 'a2' => '0', 'a3' => '1'}
        assigns[:areas].should == [['a1', true], ['a2', false], ['a3', true]]
      end

      it 'assigns to @rankables a list of Visitors in the selected Areas' do
        visitors = Array.new(3) {Admit.new}
        Admit.should_receive(:with_areas).with('a1', 'a3').and_return(visitors)
        get :add, :faculty_instance_id => @faculty_instance.id, :filter => {'a1' => '1', 'a2' => '0', 'a3' => '1'}
        assigns[:rankables].should == visitors
      end
    end

    it 'removes the currently ranked Visitors from @rankables' do
      ranked_visitor = Admit.new
      @faculty_instance.rankings.build(:rankable => ranked_visitor)
      unranked_visitors = Array.new(3) {Admit.new}
      Admit.stub(:with_areas).and_return(unranked_visitors + [ranked_visitor])
      Faculty.stub(:find).and_return(@faculty_instance)
      get :add, :faculty_instance_id => @faculty_instance.id, :filter => {'a1' => '1', 'a2' => '0', 'a3' => '1'}
      assigns[:rankables].should == unranked_visitors
    end

    it 'renders the add template' do
      get :add, :faculty_instance_id => @faculty_instance.id
      response.should render_template('add')
    end
  end

  describe 'GET edit_all' do
    it 'assigns to @ranker the Host' do
      Faculty.stub(:find).and_return(@faculty_instance)
      get :edit_all, :faculty_instance_id => @faculty_instance.id
      assigns[:ranker].should == @faculty_instance
    end

    context 'when the Host has no ranked or selected Visitors' do
      it 'redirects to the Add Rankings Page' do
        get :edit_all, :faculty_instance_id => @faculty_instance.id
        response.should redirect_to(:controller => 'host_rankings', :action => 'add', :faculty_instance_id => @faculty_instance.id)
      end
    end

    context 'when the Host has ranked some Visitors' do
      before(:each) do
        Factory.create(:host_ranking, :ranker => @faculty_instance)
      end

      it 'does not redirect to the Add Rankings Page' do
        get :edit_all, :faculty_instance_id => @faculty_instance.id
        response.should_not redirect_to(:controller => 'host_rankings', :action => 'add', :faculty_instance_id => @faculty_instance.id)
      end

      it 'renders the edit_all template' do
        get :edit_all, :faculty_instance_id => @faculty_instance.id
        response.should render_template('edit_all')
      end
    end

    context 'when the Host has selected new Visitors to rank' do
      before(:each) do
        @admits = Array.new(3) {Admit.new}
        Admit.stub(:find).and_return(@admits)
      end

      it 'finds the given Admits' do
        Admit.should_receive(:find).with(['1', '2', '3']).and_return(@admits)
        get :edit_all, :faculty_instance_id => @faculty_instance.id, :select => {'1' => '1', '2' => '1', '3' => '1', '4' => '0'}
      end

      it 'builds a new HostRanking for each given Visitor' do
        Faculty.stub(:find).and_return(@faculty_instance)
        get :edit_all, :faculty_instance_id => @faculty_instance.id, :select => {'1' => '1', '2' => '1', '3' => '1', '4' => '0'}
        @faculty_instance.rankings.map(&:rankable).should == @admits
      end

      it 'does not redirect to the Add Rankings Page' do
        get :edit_all, :faculty_instance_id => @faculty_instance.id, :select => {'1' => '1', '2' => '1', '3' => '1', '4' => '0'}
        response.should_not redirect_to(:controller => 'host_rankings', :action => 'add', :faculty_instance_id => @faculty_instance.id)
      end

      it 'renders the edit_all template' do
        get :edit_all, :faculty_instance_id => @faculty_instance.id, :select => {'1' => '1', '2' => '1', '3' => '1', '4' => '0'}
        response.should render_template('edit_all')
      end
    end
  end

  describe 'PUT update_all' do
    before(:each) do
      Faculty.stub(:find).and_return(@faculty_instance)
    end

    it 'assigns to @ranker the Host' do
      put :update_all, :faculty_instance_id => @faculty_instance.id
      assigns[:ranker].should == @faculty_instance
    end

    it 'updates the Host' do
      @faculty_instance.should_receive(:update_attributes).with('foo' => 'bar')
      put :update_all, :faculty_instance_id => @faculty_instance.id, :faculty => {'foo' => 'bar'}
    end

    context 'when the Host is successfully updated' do
      before(:each) do
        @faculty_instance.stub(:update_attributes).and_return(true)
      end

      it 'sets a flash[:notice] message' do
        put :update_all, :faculty_instance_id => @faculty_instance.id, :faculty => {'foo' => 'bar'}
        flash[:notice].should == I18n.t('people.faculty.update.success')
      end

      it 'redirects to the Edit All Rankings Page' do
        put :update_all, :faculty_instance_id => @faculty_instance.id, :faculty => {'foo' => 'bar'}
        response.should redirect_to(:controller => 'host_rankings', :action => 'edit_all', :faculty_instance_id => @faculty_instance.id)
      end
    end

    context 'the Host fails to be saved' do
      before(:each) do
        @faculty_instance.stub(:update_attributes).and_return(false)
      end

      it 'renders the Edit All Rankings Page' do
        put :update_all, :faculty_instance_id => @faculty_instance.id, :faculty => {'foo' => 'bar'}
        response.should render_template('edit_all')
      end
    end
  end
end
