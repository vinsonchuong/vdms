require 'spec_helper'

describe VisitorAvailabilitiesController do
  before(:each) do
    @visitor = Factory.create(:visitor)
    @fac = Factory.create(:person, :ldap_id => 'fac', :role => 'facilitator')
    CASClient::Frameworks::Rails::Filter.fake('fac')
    @event = @visitor.event
    Event.stub(:find).and_return(@event)
  end

  describe 'forced profile verification' do
    before(:each) do
      Visitor.stub(:find).and_return(@visitor)
    end

    context 'when an unverified Visitor is signed in' do
      before(:each) do
        @visitor.update_attribute(:verified, false)
        Person.stub(:find).and_return(@visitor.person)
      end

      it 'saves the requested URL before redirecting' do
        get :edit_all, :visitor_id => @visitor.id, :event_id => @event.id
        session[:after_verify_url].should == edit_all_event_visitor_availabilities_url(@event)
      end

      it 'redirects when editing availabilities' do
        get :edit_all, :visitor_id => @visitor.id, :event_id => @event.id
        response.should redirect_to(:controller => 'visitors', :action => 'edit', :event_id => @event.id, :id => @visitor.id)
      end

      it 'redirects when updating availabilities' do
        put :update_all, :visitor_id => @visitor.id, :event_id => @event.id
        response.should redirect_to(:controller => 'visitors', :action => 'edit', :event_id => @event.id, :id => @visitor.id)
      end
    end

    context 'when the signed in person is not an unverified Visitor' do
      before(:each) do
        Person.stub(:find).and_return(@fac)
        CASClient::Frameworks::Rails::Filter.fake('facilitator')
      end

      it 'does not redirect when editing availabilities' do
        get :edit_all, :visitor_id => @visitor.id, :event_id => @event.id
        response.should render_template('edit_all')
      end

      it 'does not redirect when updating availabilities' do
        @visitor.stub(:update_attributes).and_return(false)
        put :update_all, :visitor_id => @visitor.id, :event_id => @event.id
        response.should render_template('edit_all')
      end
    end
  end

  describe 'GET edit_all' do
    it 'assigns to @event the given Event' do
      Event.stub(:find).and_return(@event)
      get :edit_all, :visitor_id => @visitor.id, :event_id => @event.id
      assigns[:event].should == @event
    end

    it 'assigns to @schedulable the Visitor' do
      Visitor.stub(:find).and_return(@visitor)
      get :edit_all, :visitor_id => @visitor.id, :event_id => @event.id
      assigns[:schedulable].should == @visitor
    end

    it 'renders the edit_all template' do
      get :edit_all, :visitor_id => @visitor.id, :event_id => @event.id
      response.should render_template('edit_all')
    end
  end

  describe 'PUT update_all' do
    before(:each) do
      Visitor.stub(:find).and_return(@visitor)
    end

    it 'assigns to @schedulable the Visitor' do
      put :update_all, :visitor_id => @visitor.id, :event_id => @event.id
      assigns[:schedulable].should == @visitor
    end

    it 'updates the Visitor' do
      @visitor.should_receive(:update_attributes).with('foo' => 'bar')
      put :update_all, :visitor_id => @visitor.id, :event_id => @event.id, :visitor => {'foo' => 'bar'}
    end

    context 'when the Host is successfully updated' do
      before(:each) do
        @visitor.stub(:update_attributes).and_return(true)
      end

      it 'sets a flash[:notice] message' do
        put :update_all, :visitor_id => @visitor.id, :event_id => @event.id, :visitor => {'foo' => 'bar'}
        flash[:notice].should == I18n.t('visitors.update.success')
      end

      it 'redirects to the Edit All Availabilities Page' do
        put :update_all, :visitor_id => @visitor.id, :event_id => @event.id, :visitor => {'foo' => 'bar'}
        response.should redirect_to(:controller => 'visitor_availabilities', :action => 'edit_all', :visitor_id => @visitor.id)
      end
    end

    context 'the Host fails to be saved' do
      before(:each) do
        @visitor.stub(:update_attributes).and_return(false)
      end

      it 'assigns to @event the given Event' do
        Event.stub(:find).and_return(@event)
        put :update_all, :visitor_id => @visitor.id, :event_id => @event.id, :visitor => {'foo' => 'bar'}
        assigns[:event].should == @event
      end

      it 'renders the Edit All Availabilities Page' do
        put :update_all, :visitor_id => @visitor.id, :event_id => @event.id, :visitor => {'foo' => 'bar'}
        response.should render_template('edit_all')
      end
    end
  end
end

