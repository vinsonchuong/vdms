require 'spec_helper'

describe ConstraintsController do
  before(:each) do
    @feature = Factory.create(:constraint)
    @event = @feature.event
    Event.stub(:find).and_return(@event)
    @admin = Factory.create(:person, :ldap_id => 'admin', :role => 'administrator')
    CASClient::Frameworks::Rails::Filter.fake('admin')
  end

  describe 'GET index' do
    it 'assigns to @event the given Event' do
      get :index, :event_id => @event.id
      assigns[:event].should == @event
    end

    it "assigns to @features a list of the Event's Constraints" do
      features = Array.new(3) {Constraint.new}
      @event.constraints.stub(:find).and_return(features)
      get :index, :event_id => @event.id
      assigns[:features].should == features
    end

    it 'renders the index template' do
      get :index, :event_id => @event.id
      response.should render_template('index')
    end
  end

  describe 'GET new' do
    it 'assigns to @event the given Event' do
      get :new, :event_id => @event.id
      assigns[:event].should == @event
    end

    it 'assigns to @feature a new Constraint' do
      get :new, :event_id => @event.id
      feature = assigns[:feature]
      feature.should be_a_new_record
      feature.should be_a_kind_of(Constraint)
      @event.constraints.should include(feature)
    end

    context 'when a field type is not specified' do
      it 'renders the select_field_types template' do
        get :new, :event_id => @event.id
        response.should render_template('select_field_types')
      end
    end

    context 'when both field types are specified' do
      it 'renders the new template' do
        HostFieldType.stub(:find).and_return(mock_model(HostFieldType))
        VisitorFieldType.stub(:find).and_return(mock_model(VisitorFieldType))
        get :new, :event_id => @event.id, :constraint => {:host_field_type_id => 1, :visitor_field_type_id => 1}
        response.should render_template('new')
      end
    end
  end

  describe 'GET delete' do
    it 'assigns to @event the given Event' do
      get :delete, :event_id => @event.id, :id => @field_type.id
      assigns[:event].should == @event
    end

    it 'assigns to @feature the given Constraint' do
      Constraint.stub(:find).and_return(@feature)
      get :delete, :event_id => @event.id, :id => @feature.id
      assigns[:feature].should == @feature
    end

    it 'renders the edit template' do
      get :delete, :event_id => @event.id, :id => @field_type.id
      response.should render_template('delete')
    end
  end

  describe 'POST create' do
    before(:each) do
      HostFieldType.stub(:new).and_return(@field_type)
    end

    it 'assigns to @field_type a new HostFieldType with the given parameters' do
      @event.host_field_types.should_receive(:build).with('foo' => 'bar').and_return(@field_type)
      post :create, :host_field_type => {'foo' => 'bar'}, :event_id => @event.id
      assigns[:field_type].should equal(@field_type)
    end

    it 'the new HostFieldType belongs to the given Event' do
      post :create, :host_field_type => {'foo' => 'bar'}, :event_id => @event.id
      field_type = assigns[:field_type]
      field_type.event.should == @event
      @event.host_field_types.should include(field_type)
    end

    it 'saves the HostFieldType' do
      @field_type.should_receive(:save)
      post :create, :host_field_type => {'foo' => 'bar'}, :event_id => @event.id
    end

    context 'when the HostFieldType is successfully saved' do
      before(:each) do
        @field_type.stub(:save).and_return(true)
      end

      it 'sets a flash[:notice] message' do
        post :create, :host_field_type => {'foo' => 'bar'}, :event_id => @event.id
        flash[:notice].should == I18n.t('host_field_types.create.success')
      end

      it 'redirects to the View Host Field Types page' do
        post :create, :host_field_type => {'foo' => 'bar'}, :event_id => @event.id
        response.should redirect_to(:action => 'index', :event_id => @event.id)
      end
    end

    context 'when the HostFieldType fails to be saved' do
      before(:each) do
        @field_type.stub(:save).and_return(false)
      end

      it 'assigns to @event the given Event' do
        post :create, :host_field_type => {'foo' => 'bar'}, :event_id => @event.id
        assigns[:event].should == @event
      end

      it 'renders the new template' do
        post :create, :host_field_type => {'foo' => 'bar'}, :event_id => @event.id
        response.should render_template('new')
      end
    end
  end

  describe 'DELETE destroy' do
    before(:each) do
      HostFieldType.stub(:find).and_return(@field_type)
    end

    it 'destroys the HostFieldType' do
      @field_type.should_receive(:destroy)
      delete :destroy, :event_id => @event.id, :id => @field_type.id
    end

    it 'sets a flash[:notice] message' do
      delete :destroy, :event_id => @event.id, :id => @field_type.id
      flash[:notice].should == I18n.t('host_field_types.destroy.success')
    end

    it 'redirects to the View Host Field Types page' do
      delete :destroy, :event_id => @event.id, :id => @field_type.id
      response.should redirect_to(:action => 'index', :event_id => @event.id)
    end
  end
end
