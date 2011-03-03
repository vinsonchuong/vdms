require 'spec_helper'

describe StaffController do
  before(:each) do
    @staff_instance = Factory.create(:staff)
  end

  describe 'GET index' do
    context 'when not signed in' do
      it 'redirects to the CalNet sign in page' do
        get :index
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(staff_url)}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(@staff_instance.ldap_id)
      end

      it 'assigns to @staff a list of all the Staff sorted by last and first name' do
        staff = Array.new(3) {Staff.new}
        Staff.stub(:by_name).and_return(staff)
        get :index
        assigns[:staff].should == staff
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
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(delete_all_staff_url)}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(@staff_instance.ldap_id)
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
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(new_staff_instance_url)}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(@staff_instance.ldap_id)
      end

      it 'assigns to @staff_instance a new Staff' do
        get :new
        assigns[:staff_instance].should be_a_new_record
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
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(upload_staff_url)}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(@staff_instance.ldap_id)
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
        get :edit, :id => @staff_instance.id
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(edit_staff_instance_url(@staff_instance.id))}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(@staff_instance.ldap_id)
      end
  
      it 'assigns to @staff_instance the given Staff' do
        Staff.stub(:find).and_return(@staff_instance)
        get :edit, :id => @staff_instance.id
        assigns[:staff_instance].should == @staff_instance
      end

      it 'sets the error redirect to the edit action' do
        get :edit, :id => @staff_instance.id
        assigns[:origin_action].should == 'edit'
      end

      it 'sets the success redirect to the index action' do
        get :edit, :id => @staff_instance.id
        assigns[:redirect_action].should == 'index'
      end
 
      it 'renders the edit template' do
        get :edit, :id => @staff_instance.id
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
        get :edit, :id => @staff_instance.id
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
        get :edit, :id => @staff_instance.id
        response.should redirect_to(:controller => 'faculty', :action => 'new')
      end
    end
  end

  describe 'GET delete' do
    context 'when not signed in' do
      it 'redirects to the CalNet sign in page' do
        get :delete, :id => @staff_instance.id
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(delete_staff_instance_url(@staff_instance.id))}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(@staff_instance.ldap_id)
      end

      it 'assigns to @staff_instance the given Staff' do
        Staff.stub(:find).and_return(@staff_instance)
        get :delete, :id => @staff_instance.id
        assigns[:staff_instance].should == @staff_instance
      end
 
      it 'renders the delete template' do
        get :delete, :id => @staff_instance.id
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
        get :delete, :id => @staff_instance.id
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
        get :delete, :id => @staff_instance.id
        response.should redirect_to(:controller => 'faculty', :action => 'new')
      end
    end
  end

  describe 'POST create' do
    context 'when not signed in' do
      it 'redirects to the CalNet sign in page' do
        post :create
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(staff_url)}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        Staff.stub(:new).and_return(@staff_instance)
        CASClient::Frameworks::Rails::Filter.fake(@staff_instance.ldap_id)
      end

      it 'assigns to @staff_instance a new Staff with the given parameters' do
        Staff.should_receive(:new).with('foo' => 'bar').and_return(@staff_instance)
        post :create, :staff => {'foo' => 'bar'}
        assigns[:staff_instance].should equal(@staff_instance)
      end
 
      it 'saves the Staff' do
        @staff_instance.should_receive(:save)
        post :create
      end

      context 'when the Staff is successfully saved' do
        before(:each) do
          @staff_instance.stub(:save).and_return(true)
        end

        it 'sets a flash[:notice] message' do
          post :create
          flash[:notice].should == I18n.t('people.staff.create.success')
        end

        it 'redirects to the View Staff page' do
          post :create
          response.should redirect_to(:action => 'index')
        end
      end

      context 'when the Staff fails to be saved' do
        before(:each) do
          @staff_instance.stub(:save).and_return(false)
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
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(import_staff_url)}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        @csv_text = 'text'
        @staff = [Staff.new, Staff.new, Staff.new]
        Staff.stub(:new_from_csv).and_return(@staff)
        CASClient::Frameworks::Rails::Filter.fake(@staff_instance.ldap_id)
      end

      it 'assigns to @staff_instance a collection of Staff built from the attributes in each row' do
        Staff.should_receive(:new_from_csv).with(@csv_text).and_return(@staff)
        post :import, :csv_file => @csv_text
        assigns[:staff].should equal(@staff)
      end

      context 'when the Staff are all valid' do
        before(:each) do
          @staff.each {|s| s.stub(:valid?).and_return(true)}
        end

        it 'sets a flash[:notice] message' do
          post :import, :csv_file => @csv_text
          flash[:notice].should == I18n.t('people.staff.import.success')
        end

        it 'redirects to the View Staff page' do
          post :import, :csv_file => @csv_text
          response.should redirect_to(:action => 'index')
        end
      end

      context 'when not all of the Staff are valid' do
        before(:each) do
          @staff.first.stub(:valid?).and_return(false)
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
        put :update, :id => @staff_instance.id
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(staff_instance_url(@staff_instance.id))}")
      end
    end

    context 'when signed in as the given Staff' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(@staff_instance.ldap_id)
        Person.stub(:find).and_return(@staff_instance)
      end

      it 'prevents changes to the LDAP ID' do
        put :update, :id => @staff_instance.id, :staff => {:ldap_id => 'foobar'}
        assigns[:staff_instance].ldap_id.should == @staff_instance.ldap_id
      end
    end

    context 'when signed in as some other registered Staff' do
      before(:each) do
        @other_staff_instance = Factory.create(:staff)
        Person.stub(:find).and_return(@other_staff_instance)
        CASClient::Frameworks::Rails::Filter.fake(@other_staff_instance.ldap_id)
        Staff.stub(:find).and_return(@staff_instance)
      end

      it 'assigns to @staff_instance the given Staff' do
        Staff.should_receive(:find).with(@staff_instance.id.to_s).and_return(@staff_instance)
        put :update, :id => @staff_instance.id
        assigns[:staff_instance].should equal(@staff_instance)
      end

      it 'updates the Staff' do
        @staff_instance.should_receive(:update_attributes).with('foo' => 'bar')
        put :update, :id => @staff_instance.id, :staff => {'foo' => 'bar'}
      end

      context 'when the Staff is successfully updated' do
        before(:each) do
          @staff_instance.stub(:update_attributes).and_return(true)
        end
  
        it 'sets a flash[:notice] message' do
          put :update, :id => @staff_instance.id
          flash[:notice].should == I18n.t('people.staff.update.success')
        end

        it 'redirects to the given success redirect action' do
          put :update, :id => @staff_instance.id, :redirect_action => 'index'
          response.should redirect_to(:action => 'index')
        end
      end

      context 'when the Staff fails to be saved' do
        before(:each) do
          @staff_instance.stub(:update_attributes).and_return(false)
        end

        it 'sets the error redirect to the given error action' do
          put :update, :id => @staff_instance.id, :origin_action => 'edit'
          assigns[:origin_action].should == 'edit'
        end

        it 'sets the success redirect to the index action' do
          put :update, :id => @staff_instance.id, :redirect_action => 'index'
          assigns[:redirect_action].should == 'index'
        end

        it 'renders the template for the given error action' do
          put :update, :id => @staff_instance.id, :origin_action => 'edit'
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
        put :update, :id => @staff_instance.id
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
        put :update, :id => @staff_instance.id
        response.should redirect_to(:controller => 'faculty', :action => 'new')
      end
    end
  end

  describe 'DELETE destroy' do
    context 'when not signed in' do
      it 'redirects to the CalNet sign in page' do
        delete :destroy, :id => @staff_instance.id
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(staff_instance_url(@staff_instance.id))}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        Staff.stub(:find).and_return(@staff_instance)
        CASClient::Frameworks::Rails::Filter.fake(@staff_instance.ldap_id)
      end

      it 'assigns to @staff_instance the given Staff' do
        Staff.should_receive(:find).with(@staff_instance.id.to_s).and_return(@staff_instance)
        delete :destroy, :id => @staff_instance.id
        assigns[:staff_instance].should equal(@staff_instance)
      end

      it 'destroys the Staff' do
        @staff_instance.should_receive(:destroy)
        delete :destroy, :id => @staff_instance.id
      end

      it 'sets a flash[:notice] message' do
        delete :destroy, :id => @staff_instance.id
        flash[:notice].should == I18n.t('people.staff.destroy.success')
      end

      it 'redirects to the View Staff page' do
        delete :destroy, :id => @staff_instance.id
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
        delete :destroy, :id => @staff_instance.id
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
        delete :destroy, :id => @staff_instance.id
        response.should redirect_to(:controller => 'faculty', :action => 'new')
      end
    end
  end

  describe 'DELETE destroy_all' do
    context 'when not signed in' do
      it 'redirects to the CalNet sign in page' do
        delete :destroy_all
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(destroy_all_staff_url)}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(@staff_instance.ldap_id)
      end

      it 'destroys all Staff records' do
        staff = Array.new(3) {Staff.new}
        staff.each {|a| a.should_receive(:destroy)}
        Staff.stub(:find).and_return(staff)
        delete :destroy_all
      end

      it 'sets a flash[:notice] message' do
        delete :destroy_all
        flash[:notice].should == 'Staff were all successfully removed.'
      end

      it 'redirects to the View Staff page' do
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
