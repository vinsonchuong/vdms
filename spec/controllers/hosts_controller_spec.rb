require 'spec_helper'

describe HostsController do
  before(:each) do
    @host = Factory.create(:host)
    @event = @host.event
    Event.stub(:find).and_return(@event)
    @admin = Factory.create(:person, :ldap_id => 'admin', :role => 'administrator')
    CASClient::Frameworks::Rails::Filter.fake('admin')
  end

  describe 'forced profile verification' do
    before(:each) do
      Host.stub(:find).and_return(@host)
    end

    context 'when an unverified Host is signed in' do
      before(:each) do
        @host.verified = false
        @host.person.ldap_id = 'host'
        Person.stub(:find).and_return(@host.person)
        CASClient::Frameworks::Rails::Filter.fake('host')
      end

      it 'does not redirect when editing a Host' do
        get :edit, :event_id => @event.id, :id => @host.id
        response.should render_template('edit')
      end

      it 'does not redirect when updating a Host' do
        @host.stub(:update_attributes).and_return(false)
        put :update, :host => {'foo' => 'bar'}, :event_id => @event.id, :id => @host.id
        response.should render_template('edit')
      end
    end

    context 'when the signed in person is not an unverified Host' do
      it 'does not redirect when indexing Hosts' do
        get :index, :event_id => @event.id
        response.should render_template('index')
      end

      it 'does not redirect when showing a Host' do
        get :show, :event_id => @event.id, :id => @host.id
        response.should render_template('show')
      end

      it 'does not redirect when newing a Host' do
        get :new, :event_id => @event.id
        response.should render_template('new')
      end

      it 'does not redirect when editing a Host' do
        get :edit, :event_id => @event.id, :id => @host.id
        response.should render_template('edit')
      end

      it 'does not redirect when deleting a Host' do
        get :delete, :event_id => @event.id, :id => @host.id
        response.should render_template('delete')
      end

      it 'does not redirect when creating a Host' do
        Host.stub(:new).and_return(@host)
        @host.stub(:save).and_return(false)
        post :create, :host => {'foo' => 'bar'}, :event_id => @event.id
        response.should render_template('new')
      end

      it 'does not redirect when updating a Host' do
        @host.stub(:update_attributes).and_return(false)
        put :update, :host => {'foo' => 'bar'}, :event_id => @event.id, :id => @host.id
        response.should render_template('edit')
      end

      it 'does not redirect when destroying a Host' do
        Host.stub(:find).and_return(@host)
        delete :destroy, :event_id => @event.id, :id => @host.id
        response.should redirect_to(:action => 'index', :event_id => @event.id)
      end
    end
  end

  describe 'GET index' do
    it 'assigns to @event the given Event' do
      get :index, :event_id => @event.id
      assigns[:event].should == @event
    end

    it "assigns to @roles a list of the Event's Hosts sorted by Name" do
      hosts = Array.new(3) {Host.new}
      @event.hosts.stub(:find).and_return(hosts)
      get :index, :event_id => @event.id
      assigns[:roles].should == hosts
    end

    it 'renders the index template' do
      get :index, :event_id => @event.id
      response.should render_template('index')
    end
  end

  describe 'GET show' do
    it 'assigns to @event the given Event' do
      get :show, :event_id => @event.id, :id => @host.id
      assigns[:event].should == @event
    end

    it 'assigns to @roles the given Host' do
      Host.stub(:find).and_return(@host)
      get :show, :event_id => @event.id, :id => @host.id
      assigns[:role].should == @host
    end

    it 'renders the show template' do
      get :show, :event_id => @event.id, :id => @host.id
      response.should render_template('show')
    end
  end

  describe 'GET new' do
    it 'assigns to @people a list of People sorted by Name' do
      people = Array.new(3) {Person.new}
      Person.stub(:all).and_return(people)
      get :new, :event_id => @event.id
      assigns[:people].should == people
    end

    it 'assigns to @event the given Event' do
      get :new, :event_id => @event.id
      assigns[:event].should == @event
    end

    it 'assigns to @role a new Host' do
      get :new, :event_id => @event.id
      role = assigns[:role]
      role.should be_a_new_record
      role.should be_a_kind_of(Host)
      @event.hosts.should include(role)
    end

    it 'renders the new template' do
      get :new, :event_id => @event.id
      response.should render_template('new')
    end
  end

  describe 'GET join' do
    it 'assigns to @event the given Event' do
      get :join, :event_id => @event.id
      assigns[:event].should == @event
    end

    it 'renders the join template' do
      get :join, :event_id => @event.id
      response.should render_template('join')
    end
  end

  describe 'GET edit' do
    it 'assigns to @event the given Event' do
      get :edit, :event_id => @event.id, :id => @host.id
      assigns[:event].should == @event
    end

    it 'assigns to @role the given Host' do
      Host.stub(:find).and_return(@host)
      get :edit, :event_id => @event.id, :id => @host.id
      assigns[:role].should == @host
    end

    it 'renders the edit template' do
      get :edit, :event_id => @event.id, :id => @host.id
      response.should render_template('edit')
    end
  end

  describe 'GET delete' do
    it 'assigns to @event the given Event' do
      get :delete, :event_id => @event.id, :id => @host.id
      assigns[:event].should == @event
    end

    it 'assigns to @role the given Host' do
      Host.stub(:find).and_return(@host)
      get :delete, :event_id => @event.id, :id => @host.id
      assigns[:role].should == @host
    end

    it 'renders the edit template' do
      get :delete, :event_id => @event.id, :id => @host.id
      response.should render_template('delete')
    end
  end

  describe 'POST create' do
    before(:each) do
      Host.stub(:new).and_return(@host)
    end

    it 'assigns to @role a new Host with the given parameters' do
      @event.hosts.should_receive(:build).with('foo' => 'bar').and_return(@host)
      post :create, :host => {'foo' => 'bar'}, :event_id => @event.id
      assigns[:role].should equal(@host)
    end

    it 'the new Host belongs to the given Event' do
      post :create, :host => {'foo' => 'bar'}, :event_id => @event.id
      role = assigns[:role]
      role.event.should == @event
      @event.hosts.should include(role)
    end

    it 'saves the Host' do
      @host.should_receive(:save)
      post :create, :host => {'foo' => 'bar'}, :event_id => @event.id
    end

    context 'when the Host is successfully saved' do
      before(:each) do
        @host.stub(:save).and_return(true)
      end

      it 'sets a flash[:notice] message' do
        post :create, :host => {'foo' => 'bar'}, :event_id => @event.id
        flash[:notice].should == I18n.t('hosts.create.success')
      end

      it 'redirects to the View Hosts page' do
        post :create, :host => {'foo' => 'bar'}, :event_id => @event.id
        response.should redirect_to(:action => 'index', :event_id => @event.id)
      end
    end

    context 'when the Host fails to be saved' do
      before(:each) do
        @host.stub(:save).and_return(false)
      end

      it 'assigns to @event the given Event' do
        post :create, :host => {'foo' => 'bar'}, :event_id => @event.id
        assigns[:event].should == @event
      end

      it 'renders the new template' do
        post :create, :host => {'foo' => 'bar'}, :event_id => @event.id
        response.should render_template('new')
      end
    end
  end

  describe 'POST create_from_current_user' do
    context 'when signed in as a User who has not joined the Event' do
      before(:each) do
        @user = Factory.create(:person, :ldap_id => 'user', :role => 'user')
        Person.stub(:find).and_return(@user)
        CASClient::Frameworks::Rails::Filter.fake('user')
      end

      it 'adds the User as a Host of the Event' do
        @event.hosts.should_receive(:create).with(:person => @user)
        post :create_from_current_user, :event_id => @event.id
      end

      it 'redirects to the view event page' do
        post :create_from_current_user, :event_id => @event.id
        response.should redirect_to event_url(@event)
      end
    end

    context 'when signed in as a User who has already joined the Event' do
      before(:each) do
        @host.person.ldap_id = 'host'
        Person.stub(:find).and_return(@host.person)
        CASClient::Frameworks::Rails::Filter.fake('host')
      end

      it 'alerts the user that he has already joined the event'
    end
  end

  describe 'PUT update' do
    before(:each) do
      Host.stub(:find).and_return(@host)
    end

    it 'assigns to @role the given Role' do
      put :update, :host => {}, :event_id => @event.id, :id => @host.id
      assigns[:role].should equal(@host)
    end

    context 'when an Administrator is signed in' do
      it 'updates but does not verify the Host' do
        @host.should_receive(:update_attributes).with('foo' => 'bar', 'verified' => false)
        put :update, :host => {'foo' => 'bar'}, :event_id => @event.id, :id => @host.id
      end
    end

    context 'when the Host is signed in' do
      before(:each) do
        @host.person.update_attribute(:ldap_id, 'host')
        CASClient::Frameworks::Rails::Filter.fake('host')
      end

      it 'updates and verifies the Host' do
        @host.should_receive(:update_attributes).with('foo' => 'bar', 'verified' => true)
        put :update, :host => {'foo' => 'bar'}, :event_id => @event.id, :id => @host.id
      end
    end

    context 'when the Host is successfully updated' do
      before(:each) do
        @host.stub(:update_attributes).and_return(true)
      end

      context 'when signed in as the Host' do
        before(:each) do
          @host.person.ldap_id = 'host'
          Person.stub(:find).and_return(@host.person)
          CASClient::Frameworks::Rails::Filter.fake('host')
        end

        context 'when the host was unverified' do
          before(:each) do
            @host.verified = false
          end

          it 'redirects to the previously requested page' do
            session[:after_verify_url] = events_url
            put :update, :host => {'foo' => 'bar'}, :event_id => @event.id, :id => @host.id
            response.should redirect_to events_url
          end
        end

        context 'when the host was verified' do
          before(:each) do
            @host.verified = true
          end

          it 'redirects to the show event page'
        end

        it 'sets a flash[:notice] message' do
          put :update, :host => {'foo' => 'bar'}, :event_id => @event.id, :id => @host.id
          flash[:notice].should == I18n.t('hosts.update.alt_success')
        end
      end

      context 'when signed in as someone other than the Host' do
        it 'sets a flash[:notice] message' do
          put :update, :host => {'foo' => 'bar'}, :event_id => @event.id, :id => @host.id
          flash[:notice].should == I18n.t('hosts.update.success')
        end

        it 'redirects to the View Hosts page' do
          put :update, :host => {'foo' => 'bar'}, :event_id => @event.id, :id => @host.id
          response.should redirect_to(:action => 'index', :event_id => @event.id)
        end
      end
    end

    context 'when the Host fails to be updated' do
      before(:each) do
        @host.stub(:update_attributes).and_return(false)
      end

      it 'assigns to @event the given Event' do
        put :update, :host => {'foo' => 'bar'}, :event_id => @event.id, :id => @host.id
        assigns[:event].should == @event
      end

      it 'renders the edit template' do
        put :update, :host => {'foo' => 'bar'}, :event_id => @event.id, :id => @host.id
        response.should render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    before(:each) do
      Host.stub(:find).and_return(@host)
    end

    it 'destroys the Host' do
      @host.should_receive(:destroy)
      delete :destroy, :event_id => @event.id, :id => @host.id
    end

    it 'sets a flash[:notice] message' do
      delete :destroy, :event_id => @event.id, :id => @host.id
      flash[:notice].should == I18n.t('hosts.destroy.success')
    end

    it 'redirects to the View Hosts page' do
      delete :destroy, :event_id => @event.id, :id => @host.id
      response.should redirect_to(:action => 'index', :event_id => @event.id)
    end
  end
end
