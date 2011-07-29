require 'spec_helper'

describe AdmitsController do
  before(:each) do
    @staff = Factory.create(:staff)
    @admit = Factory.create(:admit)
    @peer_advisor = Factory.create(:peer_advisor)
  end

  describe 'GET index' do
    context 'when not signed in' do
      it 'redirects to the CalNet sign in page' do
        get :index
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(admits_url)}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(@staff.ldap_id)
      end

      it 'assigns to @admits a list of all the Admits sorted by last and first name' do
        admits = Array.new(3) {Admit.new}
        Admit.stub(:by_name).and_return(admits)
        get :index
        assigns[:admits].should == admits
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
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(delete_all_admits_url)}")
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
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(new_admit_url)}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(@staff.ldap_id)
      end

      it 'assigns to @admit a new Admit' do
        get :new
        assigns[:admit].should be_a_new_record
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

      it 'redirects to the New Faculty page' do
        get :new
        response.should redirect_to(:controller => 'faculty', :action => 'new')
      end
    end
  end

  describe 'GET upload' do
    context 'when not signed in' do
      it 'redirects to the CalNet sign in page' do
        get :upload
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(upload_admits_url)}")
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
        get :edit, :id => @admit.id
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(edit_admit_url(@admit.id))}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(@staff.ldap_id)
      end
  
      it 'assigns to @admit the given Admit' do
        Admit.stub(:find).and_return(@admit)
        get :edit, :id => @admit.id
        assigns[:admit].should == @admit
      end

      it 'sets the error redirect to the edit action' do
        get :edit, :id => @admit.id
        assigns[:origin_action].should == 'edit'
      end

      it 'sets the success redirect to the index action' do
        get :edit, :id => @admit.id
        assigns[:redirect_action].should == 'index'
      end
 
      it 'renders the edit template' do
        get :edit, :id => @admit.id
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
        get :edit, :id => @admit.id
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
        get :edit, :id => @admit.id
        response.should redirect_to(:controller => 'faculty', :action => 'new')
      end
    end
  end

  describe 'GET edit_availability' do
    context 'when not signed in' do
      it 'redirects to the CalNet sign in page' do
        get :edit_availability, :id => @admit.id
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(edit_availability_admit_url(@admit.id))}")
      end
    end

    context 'when signed in as a Staff'

    context 'when signed in as a registered Peer Advisor' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(@peer_advisor.ldap_id)
      end

      context 'when the Staff have disabled Peer Advisors from making further changes' do
        before(:each) do
          settings = Settings.instance
          settings.disable_peer_advisors = true
          settings.save
        end

        it 'sets a flash[:alert] message' do
          get :edit_availability, :id => @admit.id
          flash[:alert].should == I18n.t('people.admits.edit_availability.disabled')
        end
      end

      it 'assigns to @admit the given Admit' do
        get :edit_availability, :id => @admit.id
        assigns[:admit].should == @admit
      end

      it 'sets the error redirect to the schedule action' do
        get :edit_availability, :id => @admit.id
        assigns[:origin_action].should == 'edit_availability'
      end

      it 'sets the success redirect to the schedule action' do
        get :edit_availability, :id => @admit.id
        assigns[:redirect_action].should == 'edit_availability'
      end

      it 'renders the schedule template' do
        get :edit_availability, :id => @admit.id
        response.should render_template('edit_availability')
      end
    end

    context 'when signed in as an unregistered Peer Advisor' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake('12345')
        Person.stub(:find).and_return(PeerAdvisor.new)
      end

      it 'redirects to the New Peer Advisor page' do
        get :edit_availability, :id => @admit.id
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
        get :edit_availability, :id => @admit.id
        response.should redirect_to(:controller => 'faculty', :action => 'new')
      end
    end
  end

  describe 'GET delete' do
    context 'when not signed in' do
      it 'redirects to the CalNet sign in page' do
        get :delete, :id => @admit.id
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(delete_admit_url(@admit.id))}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(@staff.ldap_id)
      end

      it 'assigns to @admit the given Admit' do
        Admit.stub(:find).and_return(@admit)
        get :delete, :id => @admit.id
        assigns[:admit].should == @admit
      end
 
      it 'renders the delete template' do
        get :delete, :id => @admit.id
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
        get :delete, :id => @admit.id
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
        get :delete, :id => @admit.id
        response.should redirect_to(:controller => 'faculty', :action => 'new')
      end
    end
  end

  describe 'POST create' do
    context 'when not signed in' do
      it 'redirects to the CalNet sign in page' do
        post :create
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(admits_url)}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        Admit.stub(:new).and_return(@admit)
        CASClient::Frameworks::Rails::Filter.fake(@staff.ldap_id)
      end

      it 'assigns to @admit a new Admit with the given parameters' do
        Admit.should_receive(:new).with('foo' => 'bar').and_return(@admit)
        post :create, :admit => {'foo' => 'bar'}
        assigns[:admit].should equal(@admit)
      end
 
      it 'saves the Admit' do
        @admit.should_receive(:save)
        post :create
      end

      context 'when the Admit is successfully saved' do
        before(:each) do
          @admit.stub(:save).and_return(true)
        end

        it 'sets a flash[:notice] message' do
          post :create
          flash[:notice].should == I18n.t('people.admits.create.success')
        end

        it 'redirects to the View Admits page' do
          post :create
          response.should redirect_to(:controller => 'admits', :action => 'index')
        end
      end

      context 'when the Admit fails to be saved' do
        before(:each) do
          @admit.stub(:save).and_return(false)
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
        Person.stub(:find).and_return(Faculty.new)
      end

      it 'redirects to the New Faculty page' do
        post :create
        response.should redirect_to(:controller => 'faculty', :action => 'new')
      end
    end
  end

  describe 'POST import' do
    context 'when not signed in' do
      it 'redirects to the CalNet sign in page' do
        post :import
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(import_admits_url)}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        @csv_text = 'text'
        @admits = [Admit.new, Admit.new, Admit.new]
        Admit.stub(:new_from_csv).and_return(@admits)
        CASClient::Frameworks::Rails::Filter.fake(@staff.ldap_id)
      end

      it 'assigns to @admits a collection of Admits built from the attributes in each row' do
        Admit.should_receive(:new_from_csv).with(@csv_text).and_return(@admits)
        post :import, :csv_file => @csv_text
        assigns[:admits].should equal(@admits)
      end

      context 'when the Staffs are all valid' do
        before(:each) do
          @admits.each {|s| s.stub(:valid?).and_return(true)}
        end

        it 'sets a flash[:notice] message' do
          post :import, :csv_file => @csv_text
          flash[:notice].should == I18n.t('people.admits.import.success')
        end

        it 'redirects to the View Admit page' do
          post :import, :csv_file => @csv_text
          response.should redirect_to(:controller => 'admits', :action => 'index')
        end
      end

      context 'when not all of the Admits are valid' do
        before(:each) do
          @admits.first.stub(:valid?).and_return(false)
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
        put :update, :id => @admit.id
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(admit_url(@admit.id))}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        Admit.stub(:find).and_return(@admit)
        CASClient::Frameworks::Rails::Filter.fake(@staff.ldap_id)
        request.env['HTTP_REFERER'] = "/people/admits/#{@admit.id}/edit"
      end

      it 'assigns to @admit the given Admit' do
        Admit.should_receive(:find).with(@admit.id.to_s).and_return(@admit)
        put :update, :id => @admit.id
        assigns[:admit].should equal(@admit)
      end

      it 'updates the Admit' do
        @admit.should_receive(:update_attributes).with('foo' => 'bar')
        put :update, :id => @admit.id, :admit => {'foo' => 'bar'}
      end

      context 'when the Admit is successfully updated' do
        before(:each) do
          @admit.stub(:update_attributes).and_return(true)
        end
  
        it 'sets a flash[:notice] message' do
          put :update, :id => @admit.id
          flash[:notice].should == I18n.t('people.admits.update.success')
        end

        it 'redirects to the given success redirect action' do
          put :update, :id => @admit.id, :redirect_action => 'index'
          response.should redirect_to(:controller => 'admits', :action => 'index')
        end
      end

      context 'when the Admit fails to be saved' do
        before(:each) do
          @admit.stub(:update_attributes).and_return(false)
        end

        it 'sets the error redirect to the given error action' do
          put :update, :id => @admit.id, :origin_action => 'edit'
          assigns[:origin_action].should == 'edit'
        end

        it 'sets the success redirect to the index action' do
          put :update, :id => @admit.id, :redirect_action => 'index'
          assigns[:redirect_action].should == 'index'
        end

        it 'renders the template for the given error action' do
          put :update, :id => @admit.id, :origin_action => 'edit'
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
        put :update, :id => @admit.id
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
        put :update, :id => @admit.id
        response.should redirect_to(:controller => 'faculty', :action => 'new')
      end
    end
  end

  describe 'DELETE destroy' do
    context 'when not signed in' do
      it 'redirects to the CalNet sign in page' do
        delete :destroy, :id => @admit.id
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(admit_url(@admit.id))}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        Admit.stub(:find).and_return(@admit)
        CASClient::Frameworks::Rails::Filter.fake(@staff.ldap_id)
      end

      it 'assigns to @admit the given Admit' do
        Admit.should_receive(:find).with(@admit.id.to_s).and_return(@admit)
        delete :destroy, :id => @admit.id
        assigns[:admit].should equal(@admit)
      end

      it 'destroys the Admit' do
        @admit.should_receive(:destroy)
        delete :destroy, :id => @admit.id
      end

      it 'sets a flash[:notice] message' do
        delete :destroy, :id => @admit.id
        flash[:notice].should == I18n.t('people.admits.destroy.success')
      end

      it 'redirects to the View Admits page' do
        delete :destroy, :id => @admit.id
        response.should redirect_to(:controller => 'admits', :action => 'index')
      end
    end

    context 'when signed in as a registered Peer Advisor'

    context 'when signed in as an unregistered Peer Advisor' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake('12345')
        Person.stub(:find).and_return(PeerAdvisor.new)
      end

      it 'redirects to the New Peer Advisor page' do
        delete :destroy, :id => @admit.id
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
        delete :destroy, :id => @admit.id
        response.should redirect_to(:controller => 'faculty', :action => 'new')
      end
    end
  end

  describe 'DELETE destroy_all' do
    context 'when not signed in' do
      it 'redirects to the CalNet sign in page' do
        delete :destroy_all
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(destroy_all_admits_url)}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(@staff.ldap_id)
      end

      it 'destroys all Admit records' do
        admits = Array.new(3) {Admit.new}
        admits.each {|a| a.should_receive(:destroy)}
        Admit.stub(:find).and_return(admits)
        delete :destroy_all
      end

      it 'sets a flash[:notice] message' do
        delete :destroy_all
        flash[:notice].should == 'Admits were all successfully removed.'
      end

      it 'redirects to the View Admits page' do
        delete :destroy_all
        response.should redirect_to(:controller => 'admits', :action => 'index')
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
