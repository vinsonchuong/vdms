require 'spec_helper'

describe FacultyController do
  before(:each) do
    @staff = Factory.create(:staff)
    @faculty_instance = Factory.create(:faculty)
  end

  describe 'GET index' do
    context 'when not signed in' do
      it 'redirects to the CalNet sign in page' do
        get :index
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(faculty_url)}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(@staff.ldap_id)
      end

      it 'assigns to @faculty a list of all the Faculty sorted by last and first name' do
        faculty = Array.new(3) {Faculty.new}
        Faculty.stub(:by_name).and_return(faculty)
        get :index
        assigns[:faculty].should == faculty
      end

      it 'renders the index template' do
        get :index
        response.should render_template('index')
      end
    end

    context 'when signed in as a registered Peer Advisor'

    context 'when signed in as an unregistered Peer Advisor' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake('12345')
        Person.stub(:find).and_return(PeerAdvisor.new)
      end

      it 'redirects to the New Peer Advisor page' do
        get :index
        response.should redirect_to(:controller => 'peer_advisors', :action => 'new')
      end
    end

    context 'when signed in as a registered Faculty'

    context 'when signed in as an unregistered Faculty' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake('12345')
        Person.stub(:find).and_return(Faculty.new)
      end

      it 'redirects to the New Faculty page' do
        get :index
        response.should redirect_to(:controller => 'faculty', :action => 'new')
      end
    end
  end

  describe 'GET delete_all' do
    context 'when not signed in' do
      it 'redirects to the CalNet sign in page' do
        get :delete_all
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(delete_all_faculty_url)}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(@staff.ldap_id)
      end

      it 'renders the delete_all template' do
        get :delete_all
        response.should render_template('delete_all')
      end
    end

    context 'when signed in as a registered Peer Advisor'

    context 'when signed in as an unregistered Peer Advisor' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake('12345')
        Person.stub(:find).and_return(PeerAdvisor.new)
      end

      it 'redirects to the New Peer Advisor page' do
        get :delete_all
        response.should redirect_to(:controller => 'peer_advisors', :action => 'new')
      end
    end

    context 'when signed in as a registered Faculty'

    context 'when signed in as an unregistered Faculty' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake('12345')
        Person.stub(:find).and_return(Faculty.new)
      end

      it 'redirects to the New Faculty page' do
        get :delete_all
        response.should redirect_to(:controller => 'faculty', :action => 'new')
      end
    end
  end

  describe 'GET new' do
    context 'when not signed in' do
      it 'redirects to the CalNet sign in page' do
        get :new
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(new_faculty_instance_url)}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(@staff.ldap_id)
      end

      it 'assigns to @faculty_instance a new Faculty' do
        get :new
        assigns[:faculty_instance].should be_a_new_record
      end

      it 'assigns to @areas a list of the Areas' do
        stub_areas('A1' => 'Area 1', 'A2' => 'Area 2', 'A3' => 'Area 3')
        get :new
        assigns[:areas].should == [['Area 1', 'A1'], ['Area 2', 'A2'], ['Area 3', 'A3']]
      end

      it 'assigns to @divisions a list of the Division names' do
        stub_divisions('D1' => 'Division 1', 'D2' => 'Division 2', 'D3' => 'Division 3')
        get :new
        assigns[:divisions].should == [['Division 1', 'D1'], ['Division 2', 'D2'], ['Division 3', 'D3']]
      end

      it 'renders the new template' do
        get :new
        response.should render_template('new')
      end
    end

    context 'when signed in as a registered Peer Advisor'

    context 'when signed in as an unregistered Peer Advisor' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake('12345')
        Person.stub(:find).and_return(PeerAdvisor.new)
      end

      it 'redirects to the New Peer Advisor page' do
        get :new
        response.should redirect_to(:controller => 'peer_advisors', :action => 'new')
      end
    end

    context 'when signed in as a registered Faculty'

    context 'when signed in as an unregistered Faculty' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake('12345')
        Person.stub(:find).and_return(Faculty.new)
      end

      it 'renders the new template' do
        get :new
        response.should render_template('new')
      end
    end
  end

  describe 'GET upload' do
    context 'when not signed in' do
      it 'redirects to the CalNet sign in page' do
        get :upload
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(upload_faculty_url)}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(@staff.ldap_id)
      end

      it 'renders the upload template' do
        get :upload
        response.should render_template('upload')
      end
    end

    context 'when signed in as a registered Peer Advisor'

    context 'when signed in as an unregistered Peer Advisor' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake('12345')
        Person.stub(:find).and_return(PeerAdvisor.new)
      end

      it 'redirects to the New Peer Advisor page' do
        get :upload
        response.should redirect_to(:controller => 'peer_advisors', :action => 'new')
      end
    end

    context 'when signed in as a registered Faculty'

    context 'when signed in as an unregistered Faculty' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake('12345')
        Person.stub(:find).and_return(Faculty.new)
      end

      it 'redirects to the New Faculty page' do
        get :upload
        response.should redirect_to(:controller => 'faculty', :action => 'new')
      end
    end
  end

  describe 'GET edit' do
    context 'when not signed in' do
      it 'redirects to the CalNet sign in page' do
        get :edit, :id => @faculty_instance.id
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(edit_faculty_instance_url(@faculty_instance.id))}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(@staff.ldap_id)
      end
  
      it 'assigns to @faculty_instance the given Faculty' do
        Faculty.stub(:find).and_return(@faculty_instance)
        get :edit, :id => @faculty_instance.id
        assigns[:faculty_instance].should == @faculty_instance
      end

      it 'sets the error redirect to the edit action' do
        get :edit, :id => @faculty_instance.id
        assigns[:origin_action].should == 'edit'
      end

      it 'sets the success redirect to the index action' do
        get :edit, :id => @faculty_instance.id
        assigns[:redirect_action].should == 'index'
      end
 
      it 'renders the edit template' do
        get :edit, :id => @faculty_instance.id
        response.should render_template('edit')
      end
    end

    context 'when signed in as a registered Peer Advisor'

    context 'when signed in as an unregistered Peer Advisor' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake('12345')
        Person.stub(:find).and_return(PeerAdvisor.new)
      end

      it 'redirects to the New Peer Advisor page' do
        get :edit, :id => @faculty_instance.id
        response.should redirect_to(:controller => 'peer_advisors', :action => 'new')
      end
    end

    context 'when signed in as the given Faculty'

    context 'when signed in as some other registered Faculty'

    context 'when signed in as an unregistered Faculty' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake('12345')
        Person.stub(:find).and_return(Faculty.new)
      end

      it 'redirects to the New Faculty page' do
        get :edit, :id => @faculty_instance.id
        response.should redirect_to(:controller => 'faculty', :action => 'new')
      end
    end
  end

  describe 'GET edit_availability' do
    context 'when not signed in' do
      it 'redirects to the CalNet sign in page' do
        get :edit_availability, :id => @faculty_instance.id
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(edit_availability_faculty_instance_url(@faculty_instance.id))}")
      end
    end

    context 'when signed in as a Staff'

    context 'when signed in as a registered Peer Advisor'

    context 'when signed in as an unregistered Peer Advisor' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake('12345')
        Person.stub(:find).and_return(PeerAdvisor.new)
      end

      it 'redirects to the New Peer Advisor page' do
        get :edit_availability, :id => @faculty_instance.id
        response.should redirect_to(:controller => 'peer_advisors', :action => 'new')
      end
    end

    context 'when signed in as as the given registered Faculty' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(@faculty_instance.ldap_id)
        Faculty.stub(:find).and_return(@faculty_instance)
      end

      context 'when the Staff have disabled Faculty from making further changes' do
        before(:each) do
          settings = Settings.instance
          settings.disable_faculty = true
          settings.save
        end

        it 'sets a flash[:alert] message' do
          get :edit_availability, :id => @faculty_instance.id
          flash[:alert].should == I18n.t('people.faculty.edit_availability.disabled')
        end
      end

      it 'assigns to @faculty_instance the given Faculty' do
        get :edit_availability, :id => @faculty_instance.id
        assigns[:faculty_instance].should == @faculty_instance
      end

      it 'sets the error redirect to the schedule action' do
        get :edit_availability, :id => @faculty_instance.id
        assigns[:origin_action].should == 'edit_availability'
      end

      it 'sets the success redirect to the schedule action' do
        get :edit_availability, :id => @faculty_instance.id
        assigns[:redirect_action].should == 'edit_availability'
      end

      it 'builds a list of possible meeting slots' do
        Faculty.stub(:find).and_return(@faculty_instance)
        @faculty_instance.should_receive(:build_available_times)
        get :edit_availability, :id => @faculty_instance.id
      end

      it 'renders the schedule template' do
        get :edit_availability, :id => @faculty_instance.id
        response.should render_template('edit_availability')
      end
    end

    context 'when signed in as some other registered Faculty'

    context 'when signed in as an unregistered Faculty' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake('12345')
        Person.stub(:find).and_return(Faculty.new)
      end

      it 'redirects to the New Faculty page' do
        get :edit_availability, :id => @faculty_instance.id
        response.should redirect_to(:controller => 'faculty', :action => 'new')
      end
    end
  end

  describe 'GET rank_admits' do
    context 'when not signed in' do
      it 'redirects to the CalNet sign in page' do
        get :rank_admits, :id => @faculty_instance.id
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(rank_admits_faculty_instance_url(@faculty_instance.id))}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(@staff.ldap_id)
      end
    end

    context 'when signed in as a registered Peer Advisor'

    context 'when signed in as an unregistered Peer Advisor' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake('12345')
        Person.stub(:find).and_return(PeerAdvisor.new)
      end

      it 'redirects to the New Peer Advisor page' do
        get :rank_admits, :id => @faculty_instance.id
        response.should redirect_to(:controller => 'peer_advisors', :action => 'new')
      end
    end

    context 'when signed in as the given Faculty' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(@faculty_instance.ldap_id)
        Person.stub(:find).and_return(@faculty_instance)
      end

      it 'assigns to @faculty_instance the given Faculty' do
        Faculty.stub(:find).and_return(@faculty_instance)
        get :rank_admits, :id => @faculty_instance.id
        assigns[:faculty_instance].should == @faculty_instance
      end

      context 'when the Staff have disabled Faculty from making further changes' do
        before(:each) do
          settings = Settings.instance
          settings.disable_faculty = true
          settings.save
        end

        it 'sets a flash[:alert] message' do
          get :rank_admits, :id => @faculty_instance.id
          flash[:alert].should == I18n.t('people.faculty.rank_admits.disabled')
        end

        it 'does not redirect to select_admits' do
          get :rank_admits, :id => @faculty_instance.id
          response.should_not redirect_to(:action => 'select_admits')
        end

        it 'renders the select_admits template' do
          get :rank_admits, :id => @faculty_instance.id
          response.should render_template('rank_admits')
        end
      end

      context 'when the Faculty has not ranked or selected any Admits' do
        it 'does redirects to select_admits' do
          get :rank_admits, :id => @faculty_instance.id
          response.should redirect_to(:action => 'select_admits')
        end
      end

      context 'when the Faculty has ranked but not selected any Admits' do
        before(:each) do
          Factory.create(:admit_ranking, :faculty => @faculty_instance)
        end

        it 'sets the error redirect to the rank_admits action' do
          get :rank_admits, :id => @faculty_instance.id
          assigns[:origin_action].should == 'rank_admits'
        end

        it 'sets the success redirect to the rank_admits action' do
          get :rank_admits, :id => @faculty_instance.id
          assigns[:redirect_action].should == 'rank_admits'
        end

        it 'does not redirect to select_admits' do
          get :rank_admits, :id => @faculty_instance.id
          response.should_not redirect_to(:action => 'select_admits')
        end

        it 'renders the select_admits template' do
          get :rank_admits, :id => @faculty_instance.id
          response.should render_template('rank_admits')
        end
      end

      context 'when the Faculty has selected some Admits to rank' do
        before(:each) do
          @admits = Array.new(3) {Admit.new}
          Admit.stub(:find).and_return(@admits)
        end

        it 'finds the given Admits' do
          Admit.should_receive(:find).with(['1', '2', '3']).and_return(@admits)
          get :rank_admits, :id => @faculty_instance.id, :select => {'1' => '1', '2' => '1', '3' => '1', '4' => '0'}
        end

        it 'builds a new AdmitRanking for each given Admit' do
          Faculty.stub(:find).and_return(@faculty_instance)
          get :rank_admits, :id => @faculty_instance.id, :select => {'1' => '1', '2' => '1', '3' => '1', '4' => '0'}
          @faculty_instance.admit_rankings.map(&:admit).should == @admits
        end

        it 'sets the error redirect to the rank_admits action' do
          get :rank_admits, :id => @faculty_instance.id, :select => {'1' => '1', '2' => '1', '3' => '1', '4' => '0'}
          assigns[:origin_action].should == 'rank_admits'
        end

        it 'sets the success redirect to the rank_admits action' do
          get :rank_admits, :id => @faculty_instance.id, :select => {'1' => '1', '2' => '1', '3' => '1', '4' => '0'}
          assigns[:redirect_action].should == 'rank_admits'
        end

        it 'does not redirect to select_admits' do
          get :rank_admits, :id => @faculty_instance.id, :select => {'1' => '1', '2' => '1', '3' => '1', '4' => '0'}
          response.should_not redirect_to(:action => 'select_admits')
        end

        it 'renders the select_admits template' do
          get :rank_admits, :id => @faculty_instance.id, :select => {'1' => '1', '2' => '1', '3' => '1', '4' => '0'}
          response.should render_template('rank_admits')
        end
      end
    end

    context 'when signed in as some other registered Faculty'

    context 'when signed in as an unregistered Faculty' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake('12345')
        Person.stub(:find).and_return(Faculty.new)
      end

      it 'redirects to the New Faculty page' do
        get :rank_admits, :id => @faculty_instance.id
        response.should redirect_to(:controller => 'faculty', :action => 'new')
      end
    end
  end

  describe 'GET select_admits' do
    context 'when not signed in' do
      it 'redirects to the CalNet sign in page' do
        get :select_admits, :id => @faculty_instance.id
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(select_admits_faculty_instance_url(@faculty_instance.id))}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(@staff.ldap_id)
      end

      it 'renders the select_admits template' do
        get :select_admits, :id => @faculty_instance.id
        response.should render_template('select_admits')
      end
    end

    context 'when signed in as a registered Peer Advisor'

    context 'when signed in as an unregistered Peer Advisor' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake('12345')
        Person.stub(:find).and_return(PeerAdvisor.new)
      end

      it 'redirects to the New Peer Advisor page' do
        get :select_admits, :id => @faculty_instance.id
        response.should redirect_to(:controller => 'peer_advisors', :action => 'new')
      end
    end

    context 'when signed in as the given Faculty' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(@faculty_instance.ldap_id)
      end

      it 'assigns to @faculty_instance the given Faculty' do
        Faculty.stub(:find).and_return(@faculty_instance)
        get :select_admits, :id => @faculty_instance.id
        assigns[:faculty_instance].should == @faculty_instance
      end

      context 'when given no filter' do
        it 'assigns to @admits a sorted list of all the Admits' do
          admits = Array.new(3) {Admit.new}
          Admit.should_receive(:by_name).and_return(admits)
          get :select_admits, :id => @faculty_instance.id
          assigns[:admits].should == admits
        end

        it 'removes the currently ranked Admits from @admits' do
          admit = Admit.new
          admits = Array.new(3) {Admit.new}
          Admit.stub(:by_name).and_return(admits + [admit])
          @faculty_instance.admit_rankings.build(:admit => admit)
          Faculty.stub(:find).and_return(@faculty_instance)
          get :select_admits, :id => @faculty_instance.id
          assigns[:admits].should == admits
        end
      end

      context 'when given a filter' do
        it 'assigns to @admits a sorted list of Admits in the given Areas' do
          admits = Array.new(3) {Admit.new}
          Admit.should_receive(:with_areas).with('a1', 'a3').and_return(admits)
          get :select_admits, :id => @faculty_instance.id, :filter => {'a1' => '1', 'a2' => '0', 'a3' => '1'}
          assigns[:admits].should == admits
        end

        it 'removes the currently ranked Admits from @admits' do
          admit = Admit.new
          admits = Array.new(3) {Admit.new}
          Admit.stub(:with_areas).and_return(admits + [admit])
          @faculty_instance.admit_rankings.build(:admit => admit)
          Faculty.stub(:find).and_return(@faculty_instance)
          get :select_admits, :id => @faculty_instance.id, :filter => {'a1' => '1', 'a2' => '0', 'a3' => '1'}
          assigns[:admits].should == admits
        end
      end

      it 'renders the select_admits template' do
        get :select_admits, :id => @faculty_instance.id
        response.should render_template('select_admits')
      end
    end

    context 'when signed in as some other registered Faculty'

    context 'when signed in as an unregistered Faculty' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake('12345')
        Person.stub(:find).and_return(Faculty.new)
      end

      it 'redirects to the New Faculty page' do
        get :select_admits, :id => @faculty_instance.id
        response.should redirect_to(:controller => 'faculty', :action => 'new')
      end
    end
  end

  describe 'GET delete' do
    context 'when not signed in' do
      it 'redirects to the CalNet sign in page' do
        get :delete, :id => @faculty_instance.id
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(delete_faculty_instance_url(@faculty_instance.id))}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(@staff.ldap_id)
      end

      it 'assigns to @faculty_instance the given Faculty' do
        Faculty.stub(:find).and_return(@faculty_instance)
        get :delete, :id => @faculty_instance.id
        assigns[:faculty_instance].should == @faculty_instance
      end
 
      it 'renders the delete template' do
        get :delete, :id => @faculty_instance.id
        response.should render_template('delete')
      end
    end

    context 'when signed in as a registered Peer Advisor'

    context 'when signed in as an unregistered Peer Advisor' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake('12345')
        Person.stub(:find).and_return(PeerAdvisor.new)
      end

      it 'redirects to the New Peer Advisor page' do
        get :delete, :id => @faculty_instance.id
        response.should redirect_to(:controller => 'peer_advisors', :action => 'new')
      end
    end

    context 'when signed in as a registered Faculty'

    context 'when signed in as an unregistered Faculty' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake('12345')
        Person.stub(:find).and_return(Faculty.new)
      end

      it 'redirects to the New Faculty page' do
        get :delete, :id => @faculty_instance.id
        response.should redirect_to(:controller => 'faculty', :action => 'new')
      end
    end
  end

  describe 'POST create' do
    context 'when not signed in' do
      it 'redirects to the CalNet sign in page' do
        post :create
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(faculty_url)}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        Faculty.stub(:new).and_return(@faculty_instance)
        CASClient::Frameworks::Rails::Filter.fake(@staff.ldap_id)
      end

      it 'assigns to @faculty_instance a new Faculty with the given parameters' do
        Faculty.should_receive(:new).with('foo' => 'bar').and_return(@faculty_instance)
        post :create, :faculty => {'foo' => 'bar'}
        assigns[:faculty_instance].should equal(@faculty_instance)
      end
 
      it 'saves the Faculty' do
        @faculty_instance.should_receive(:save)
        post :create
      end

      context 'when the Faculty is successfully saved' do
        before(:each) do
          @faculty_instance.stub(:save).and_return(true)
        end

        it 'sets a flash[:notice] message' do
          post :create
          flash[:notice].should == I18n.t('people.faculty.create.success')
        end

        it 'redirects to the View Faculty page' do
          post :create
          response.should redirect_to(:action => 'index')
        end
      end

      context 'when the Faculty fails to be saved' do
        before(:each) do
          @faculty_instance.stub(:save).and_return(false)
        end

        it 'renders the new template' do
          post :create
          response.should render_template('new')
        end
      end
    end

    context 'when signed in as a registered Peer Advisor'

    context 'when signed in as an unregistered Peer Advisor' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake('12345')
        Person.stub(:find).and_return(PeerAdvisor.new)
      end

      it 'redirects to the New Peer Advisor page' do
        post :create
        response.should redirect_to(:controller => 'peer_advisors', :action => 'new')
      end
    end

    context 'when signed in as a registered Faculty'

    context 'when signed in as an unregistered Faculty' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake('12345')
        Person.stub(:find).and_return(Faculty.new(:ldap_id => '12345'))
      end

      it 'assigns to @faculty_instance a Faculty with the same LDAP UID as the logged in user' do
        post :create
        assigns[:faculty_instance].ldap_id.should == '12345'
      end

      it 'saves the Faculty' do
        Faculty.stub(:new).and_return(@faculty_instance)
        @faculty_instance.should_receive(:save)
        post :create
      end

      it 'redirects to the Faculty Dashboard on success' do
        Faculty.stub(:new).and_return(@faculty_instance)
        @faculty_instance.stub(:new_record?).and_return(true)
        @faculty_instance.stub(:save).and_return(true)
        post :create
        response.should redirect_to(:controller => 'root', :action => 'faculty_dashboard')
      end
    end
  end

  describe 'POST import' do
    context 'when not signed in' do
      it 'redirects to the CalNet sign in page' do
        post :import
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(import_faculty_url)}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        @csv_text = 'text'
        @faculty = [Faculty.new, Faculty.new, Faculty.new]
        Faculty.stub(:new_from_csv).and_return(@faculty)
        CASClient::Frameworks::Rails::Filter.fake(@staff.ldap_id)
      end

      it 'assigns to @faculty a collection of Faculty built from the attributes in each row' do
        Faculty.should_receive(:new_from_csv).with(@csv_text).and_return(@faculty)
        post :import, :csv_file => @csv_text
        assigns[:faculty].should equal(@faculty)
      end

      context 'when the Faculty are all valid' do
        before(:each) do
          @faculty.each {|s| s.stub(:valid?).and_return(true)}
        end

        it 'sets a flash[:notice] message' do
          post :import, :csv_file => @csv_text
          flash[:notice].should == I18n.t('people.faculty.import.success')
        end

        it 'redirects to the View Faculty page' do
          post :import, :csv_file => @csv_text
          response.should redirect_to(:action => 'index')
        end
      end

      context 'when not all of the Faculty are valid' do
        before(:each) do
          @faculty.first.stub(:valid?).and_return(false)
        end

        it 'renders the upload template' do
          post :import, :csv_file => @csv_text
          response.should render_template('upload')
        end
      end
    end

    context 'when signed in as a registered Peer Advisor'

    context 'when signed in as an unregistered Peer Advisor' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake('12345')
        Person.stub(:find).and_return(PeerAdvisor.new)
      end

      it 'redirects to the New Peer Advisor page' do
        post :import
        response.should redirect_to(:controller => 'peer_advisors', :action => 'new')
      end
    end

    context 'when signed in as a registered Faculty'

    context 'when signed in as an unregistered Faculty' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake('12345')
        Person.stub(:find).and_return(Faculty.new)
      end

      it 'redirects to the New Faculty page' do
        post :import
        response.should redirect_to(:controller => 'faculty', :action => 'new')
      end
    end
  end

  describe 'PUT update' do
    context 'when not signed in' do
      it 'redirects to the CalNet sign in page' do
        put :update, :id => @faculty_instance.id
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(faculty_instance_url(@faculty_instance.id))}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        Faculty.stub(:find).and_return(@faculty_instance)
        CASClient::Frameworks::Rails::Filter.fake(@staff.ldap_id)
      end

      it 'assigns to @faculty_instance the given Faculty' do
        Faculty.should_receive(:find).with(@faculty_instance.id.to_s).and_return(@faculty_instance)
        put :update, :id => @faculty_instance.id
        assigns[:faculty_instance].should equal(@faculty_instance)
      end

      it 'updates the Faculty' do
        @faculty_instance.should_receive(:update_attributes).with('foo' => 'bar')
        put :update, :id => @faculty_instance.id, :faculty => {'foo' => 'bar'}
      end

      context 'when the Faculty is successfully updated' do
        before(:each) do
          @faculty_instance.stub(:update_attributes).and_return(true)
        end
  
        it 'sets a flash[:notice] message' do
          put :update, :id => @faculty_instance.id
          flash[:notice].should == I18n.t('people.faculty.update.success')
        end

        it 'redirects to the given success redirect action' do
          put :update, :id => @faculty_instance.id, :redirect_action => 'index'
          response.should redirect_to(:action => 'index')
        end
      end

      context 'when the Faculty fails to be saved' do
        before(:each) do
          @faculty_instance.stub(:update_attributes).and_return(false)
        end

        it 'sets the error redirect to the given error action' do
          put :update, :id => @faculty_instance.id, :origin_action => 'edit'
          assigns[:origin_action].should == 'edit'
        end

        it 'sets the success redirect to the index action' do
          put :update, :id => @faculty_instance.id, :redirect_action => 'index'
          assigns[:redirect_action].should == 'index'
        end

        it 'renders the template for the given error action' do
          put :update, :id => @faculty_instance.id, :origin_action => 'edit'
          response.should render_template('edit')
        end
      end
    end

    context 'when signed in as a registered Peer Advisor'

    context 'when signed in as an unregistered Peer Advisor' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake('12345')
        Person.stub(:find).and_return(PeerAdvisor.new)
      end

      it 'redirects to the New Peer Advisor page' do
        put :update, :id => @faculty_instance.id
        response.should redirect_to(:controller => 'peer_advisors', :action => 'new')
      end
    end

    context 'when signed in as the given Faculty' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(@faculty_instance.ldap_id)
        Person.stub(:find).and_return(@faculty_instance)
      end

      it 'prevents changes to the LDAP ID' do
        put :update, :id => @faculty_instance.id, :faculty => {:ldap_id => 'foobar'}
        assigns[:faculty_instance].ldap_id.should == @faculty_instance.ldap_id
      end
    end

    context 'when signed in as some other registered Faculty'

    context 'when signed in as an unregistered Faculty' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake('12345')
        Person.stub(:find).and_return(Faculty.new)
      end

      it 'redirects to the New Faculty page' do
        put :update, :id => @faculty_instance.id
        response.should redirect_to(:controller => 'faculty', :action => 'new')
      end
    end
  end

  describe 'DELETE destroy' do
    context 'when not signed in' do
      it 'redirects to the CalNet sign in page' do
        delete :destroy, :id => @faculty_instance.id
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(faculty_instance_url(@faculty_instance.id))}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        Faculty.stub(:find).and_return(@faculty_instance)
        CASClient::Frameworks::Rails::Filter.fake(@staff.ldap_id)
      end

      it 'assigns to @faculty_instance the given Faculty' do
        Faculty.should_receive(:find).with(@faculty_instance.id.to_s).and_return(@faculty_instance)
        delete :destroy, :id => @faculty_instance.id
        assigns[:faculty_instance].should equal(@faculty_instance)
      end

      it 'destroys the Faculty' do
        @faculty_instance.should_receive(:destroy)
        delete :destroy, :id => @faculty_instance.id
      end

      it 'sets a flash[:notice] message' do
        delete :destroy, :id => @faculty_instance.id
        flash[:notice].should == I18n.t('people.faculty.destroy.success')
      end

      it 'redirects to the View Faculty page' do
        delete :destroy, :id => @faculty_instance.id
        response.should redirect_to(:action => 'index')
      end
    end

    context 'when signed in as a registered Peer Advisor'

    context 'when signed in as an unregistered Peer Advisor' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake('12345')
        Person.stub(:find).and_return(PeerAdvisor.new)
      end

      it 'redirects to the New Peer Advisor page' do
        delete :destroy, :id => @faculty_instance.id
        response.should redirect_to(:controller => 'peer_advisors', :action => 'new')
      end
    end

    context 'when signed in as a registered Faculty'

    context 'when signed in as an unregistered Faculty' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake('12345')
        Person.stub(:find).and_return(Faculty.new)
      end

      it 'redirects to the New Faculty page' do
        delete :destroy, :id => @faculty_instance.id
        response.should redirect_to(:controller => 'faculty', :action => 'new')
      end
    end
  end

  describe 'DELETE destroy_all' do
    context 'when not signed in' do
      it 'redirects to the CalNet sign in page' do
        delete :destroy_all
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(destroy_all_faculty_url)}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(@staff.ldap_id)
      end

      it 'destroys all Faculty records' do
        faculty = Array.new(3) {Faculty.new}
        faculty.each {|f| f.should_receive(:destroy)}
        Faculty.stub(:find).and_return(faculty)
        delete :destroy_all
      end

      it 'sets a flash[:notice] message' do
        delete :destroy_all
        flash[:notice].should == 'Faculty were all successfully removed.'
      end

      it 'redirects to the View Faculty page' do
        delete :destroy_all
        response.should redirect_to(:action => 'index')
      end
    end

    context 'when signed in as a registered Peer Advisor'

    context 'when signed in as an unregistered Peer Advisor' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake('12345')
        Person.stub(:find).and_return(PeerAdvisor.new)
      end

      it 'redirects to the New Peer Advisor page' do
        delete :destroy_all
        response.should redirect_to(:controller => 'peer_advisors', :action => 'new')
      end
    end

    context 'when signed in as a registered Faculty'

    context 'when signed in as an unregistered Faculty' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake('12345')
        Person.stub(:find).and_return(Faculty.new)
      end

      it 'redirects to the New Faculty page' do
        delete :destroy_all
        response.should redirect_to(:controller => 'faculty', :action => 'new')
      end
    end
  end
end
