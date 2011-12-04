require 'spec_helper'

describe HostAvailabilitiesController do
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
        Person.stub(:find).and_return(@host.person)
      end

      it 'saves the requested URL before redirecting' do
        get :edit_all, :host_id => @host.id, :event_id => @event.id
        session[:after_verify_url].should == edit_all_event_host_availabilities_url(@event)
      end

      it 'redirects when editing availabilities' do
        get :edit_all, :host_id => @host.id, :event_id => @event.id
        response.should redirect_to(:controller => 'hosts', :action => 'edit', :event_id => @event.id, :id => @host.id)
      end

      it 'redirects when updating availabilities' do
        put :update_all, :host_id => @host.id, :event_id => @event.id
        response.should redirect_to(:controller => 'hosts', :action => 'edit', :event_id => @event.id, :id => @host.id)
      end
    end

    context 'when the signed in person is not an unverified Host' do
      before(:each) do
        Person.stub(:find).and_return(Factory.create(:person, :role => 'administrator', :ldap_id => 'administrator'))
        RubyCAS::Filter.fake('administrator')
      end

      it 'does not redirect when editing availabilities' do
        get :edit_all, :host_id => @host.id, :event_id => @event.id
        response.should render_template('edit_all')
      end

      it 'does not redirect when updating availabilities' do
        @host.stub(:update_attributes).and_return(false)
        @host.stub(:errors).and_return(:error => '')
        put :update_all, :host_id => @host.id, :event_id => @event.id
        response.should render_template('edit_all')
      end
    end
  end

  describe 'GET edit_all' do
    it 'assigns to @event the given Event' do
      Event.stub(:find).and_return(@event)
      get :edit_all, :host_id => @host.id, :event_id => @event.id
      assigns[:event].should == @event
    end

    it 'assigns to @schedulable the Host' do
      @event.stub_chain(:hosts, :find).and_return(@host)
      get :edit_all, :host_id => @host.id, :event_id => @event.id
      assigns[:schedulable].should == @host
    end

    it 'renders the edit_all template' do
      get :edit_all, :host_id => @host.id, :event_id => @event.id
      response.should render_template('edit_all')
    end
  end

  describe 'PUT update_all' do
    before(:each) do
      @event.stub_chain(:hosts, :find).and_return(@host)
    end

    it 'assigns to @schedulable the Host' do
      put :update_all, :host_id => @host.id, :event_id => @event.id
      assigns[:schedulable].should == @host
    end

    it 'updates the Host' do
      @host.should_receive(:update_attributes).with('foo' => 'bar')
      put :update_all, :host_id => @host.id, :host => {'foo' => 'bar'}, :event_id => @event.id
    end

    context 'when the Host is successfully updated' do
      before(:each) do
        @host.stub(:update_attributes).and_return(true)
      end

      context 'when the Host is signed in' do
        it 'sets a flash[:notice] message' do
          put :update_all, :host_id => @host.id, :host => {'foo' => 'bar'}, :event_id => @event.id
          flash[:notice].should == I18n.t('hosts.update.alt_success')
        end
      end

      context 'when someone other than the Host is signed in' do
        before(:each) do
          @admin = Factory.create(:person, :ldap_id => 'admin', :role => 'administrator')
          RubyCAS::Filter.fake('admin')
        end

        it 'sets a flash[:notice] message' do
          put :update_all, :host_id => @host.id, :host => {'foo' => 'bar'}, :event_id => @event.id
          flash[:notice].should == I18n.t('hosts.update.success')
        end
      end

      it 'redirects to the Edit All Availabilities Page' do
        put :update_all, :host_id => @host.id, :host => {'foo' => 'bar'}, :event_id => @event.id
        response.should redirect_to(:controller => 'host_availabilities', :action => 'edit_all', :host_id => @host.id)
      end
    end

    context 'the Host fails to be saved' do
      before(:each) do
        @host.stub(:update_attributes).and_return(false)
        @host.stub(:errors).and_return(:error => '')
      end

      it 'assigns to @event the given Event' do
        Event.stub(:find).and_return(@event)
        put :update_all, :host_id => @host.id, :host => {'foo' => 'bar'}, :event_id => @event.id
        assigns[:event].should == @event
      end

      it 'renders the Edit All Availabilities Page' do
        put :update_all, :host_id => @host.id, :host => {'foo' => 'bar'}, :event_id => @event.id
        response.should render_template('edit_all')
      end
    end
  end
end
