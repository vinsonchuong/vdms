require 'spec_helper'

describe ConstraintsController do
  before(:each) do
    @feature = Factory.create(:constraint)
    @event = @feature.event
    Event.stub(:find).and_return(@event)
    @admin = Factory.create(:person, :ldap_id => 'admin', :role => 'administrator')
    RubyCAS::Filter.fake('admin')
  end

  describe 'GET index' do
    it 'assigns to @event the given Event' do
      get :index, :event_id => @event.id
      assigns[:event].should == @event
    end

    it "assigns to @features a list of the Event's Constraints" do
      features = Array.new(3) {Constraint.new}
      @event.stub(:constraints).and_return(features)
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
        Feature.stub(:new).and_return(@feature)
        get :new, :event_id => @event.id, :constraint => {:host_field_type_id => 1, :visitor_field_type_id => 1}
        response.should render_template('new')
      end
    end
  end

  describe 'GET delete' do
    it 'assigns to @event the given Event' do
      get :delete, :event_id => @event.id, :id => @feature.id
      assigns[:event].should == @event
    end

    it 'assigns to @feature the given Constraint' do
      Constraint.stub(:find).and_return(@feature)
      get :delete, :event_id => @event.id, :id => @feature.id
      assigns[:feature].should == @feature
    end

    it 'renders the edit template' do
      get :delete, :event_id => @event.id, :id => @feature.id
      response.should render_template('delete')
    end
  end
end
