require 'spec_helper'

describe EventsController do
  before(:each) do
    @admin = Factory.create(:person, :ldap_id => 'admin', :role => 'administrator')
    RubyCAS::Filter.fake('admin')
    @event = Factory.create(:event)
  end

  describe 'GET index' do
    it "assigns to @user_events a list of the current user's Events" do
      events = Array.new(3) {Event.new}
      @admin.stub(:events).and_return(events)
      Person.stub(:find_by_ldap_id).and_return(@admin)
      get :index
      assigns[:user_events].should == events
    end

    it 'assigns to @other_events a list of Events that the current user has not joined' do
      user_events = Array.new(3) {Event.new}
      @admin.stub(:events).and_return(user_events)
      Person.stub(:find_by_ldap_id).and_return(@admin)
      other_events = Array.new(3) {Event.new}
      Event.stub(:all).and_return(user_events + other_events)
      get :index
      assigns[:other_events].should == other_events
    end

    it 'renders the index template' do
      get :index
      response.should render_template('index')
    end
  end

  describe 'GET show' do
    it 'assigns to @event the given Event' do
      Event.stub(:find).and_return(@event)
      get :show, :id => @event.id
      assigns[:event].should == @event
    end

    it 'renders the show template' do
      get :show, :id => @event.id
      response.should render_template('show')
    end
  end

  describe 'GET new' do
    it 'assigns to @event a new Event' do
      get :new
      assigns[:event].should be_a_new_record
    end

    it 'renders thew new template' do
      get :new
      response.should render_template('new')
    end
  end

  describe 'GET edit' do
    it 'assigns to @event the given Event' do
      Event.stub(:find).and_return(@event)
      get :edit, :id => @event.id
      assigns[:event].should == @event
    end

    it 'assigns to @meeting_times a list of Meeting Times with a blank' do
      Event.stub(:find).and_return(@event)
      meeting_times = [1..2, 2..3]
      @event.should_receive(:meeting_times).with(:include_blank => true).and_return(meeting_times)
      get :edit, :id => @event.id
      assigns[:meeting_times].should == meeting_times
    end

    it 'renders the edit template' do
      get :edit, :id => @event.id
      response.should render_template('edit')
    end
  end

  describe 'GET delete' do
    it 'assigns to @event the given Event' do
      Event.stub(:find).and_return(@event)
      get :delete, :id => @event.id
      assigns[:event].should == @event
    end

    it 'renders the delete template' do
      get :delete, :id => @event.id
      response.should render_template('delete')
    end
  end

  describe 'POST create' do
    before(:each) do
      Event.stub(:new).and_return(@event)
    end

    it 'assigns to @event a new Event with the given parameters' do
      Event.should_receive(:new).with('foo' => 'bar').and_return(@event)
      post :create, :event => {'foo' => 'bar'}
      assigns[:event].should equal(@event)
    end

    it 'saves the Event' do
      @event.should_receive(:save)
      post :create, :event => {'foo' => 'bar'}
    end

    context 'when the Event is successfully saved' do
      before(:each) do
        @event.stub(:save).and_return(true)
      end

      it 'sets a flash[:notice] message' do
        post :create, :event => {'foo' => 'bar'}
        flash[:notice].should == I18n.t('events.create.success')
      end

      it 'redirects to the View Meeting page' do
        post :create, :event => {'foo' => 'bar'}
        response.should redirect_to(:action => 'show', :id => @event.id)
      end
    end

    context 'when the Event fails to be saved' do
      before(:each) do
        @event.stub(:save).and_return(false)
        @event.stub(:errors).and_return(:error => 'foo')
      end

      it 'renders the new template' do
        post :create, :event => {'foo' => 'bar'}
        response.should render_template('new')
      end
    end

    describe 'PUT update' do
      before(:each) do
        Event.stub(:find).and_return(@event)
      end

      it 'assigns to @event the given Event' do
        put :update, :id => @event.id
        assigns[:event].should == @event
      end

      it 'updates the Event' do
        @event.should_receive(:update_attributes).with('foo' => 'bar')
        put :update, :id => @event.id, :event => {'foo' => 'bar'}
      end

      context 'when the Event is successfully updated' do
        before(:each) do
          @event.stub(:update_attributes).and_return(true)
        end

        it 'sets a flash[:notice] message' do
          put :update, :id => @event.id, :event => {'foo' => 'bar'}
          flash[:notice].should == I18n.t('events.update.success')
        end

        it 'redirects to the View Event page' do
          put :update, :id => @event.id, :event => {'foo' => 'bar'}
          response.should redirect_to(:action => 'edit', :id => @event.id)
        end
      end

      context 'when the Event fails to be saved' do
        before(:each) do
          @event.stub(:update_attributes).and_return(false)
          @event.stub(:errors).and_return(:error => '')
        end

        it 'renders the edit template' do
          put :update, :id => @event.id, :event => {'foo' => 'bar'}
          response.should render_template('edit')
        end
      end
    end

    describe 'DELETE destroy' do
      before(:each) do
        Event.stub(:find).and_return(@event)
      end

      it 'destroys the Event' do
        @event.should_receive(:destroy)
        delete :destroy, :id => @event.id
      end

      it 'sets a flash[:notice] message' do
        delete :destroy, :id => @event.id
        flash[:notice].should == I18n.t('events.destroy.success')
      end

      it 'redirects to the View Events page' do
        delete :destroy, :id => @event.id
        response.should redirect_to(:action => 'index')
      end
    end
  end
end
