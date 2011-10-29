require 'spec_helper'

describe HostAvailabilitiesController do
  before(:each) do
    @host = Factory.create(:host)
    @host.person.update_attribute(:ldap_id, 'host')
    CASClient::Frameworks::Rails::Filter.fake('host')
    @event = @host.event
  end

  describe 'GET edit_all' do
    it 'assigns to @event the given Event' do
      Event.stub(:find).and_return(@event)
      get :edit_all, :host_id => @host.id, :event_id => @event.id
      assigns[:event].should == @event
    end

    it 'assigns to @schedulable the Host' do
      Host.stub(:find).and_return(@host)
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
      Host.stub(:find).and_return(@host)
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

      it 'sets a flash[:notice] message' do
        put :update_all, :host_id => @host.id, :host => {'foo' => 'bar'}, :event_id => @event.id
        flash[:notice].should == I18n.t('hosts.update.success')
      end

      it 'redirects to the Edit All Availabilities Page' do
        put :update_all, :host_id => @host.id, :host => {'foo' => 'bar'}, :event_id => @event.id
        response.should redirect_to(:controller => 'host_availabilities', :action => 'edit_all', :host_id => @host.id)
      end
    end

    context 'the Host fails to be saved' do
      before(:each) do
        @host.stub(:update_attributes).and_return(false)
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
