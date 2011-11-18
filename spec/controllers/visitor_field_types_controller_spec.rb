require 'spec_helper'

describe VisitorFieldTypesController do
  before(:each) do
    @field_type = Factory.create(:visitor_field_type)
    @event = @field_type.event
    Event.stub(:find).and_return(@event)
    @admin = Factory.create(:person, :ldap_id => 'admin', :role => 'administrator')
    CASClient::Frameworks::Rails::Filter.fake('admin')
  end

  describe 'GET index' do
    it 'assigns to @event the given Event' do
      get :index, :event_id => @event.id
      assigns[:event].should == @event
    end

    it "assigns to @field_types a list of the Event's VisitorFieldTypes" do
      field_types = Array.new(3) {VisitorFieldType.new}
      @event.visitor_field_types.stub(:find).and_return(field_types)
      get :index, :event_id => @event.id
      assigns[:field_types].should == field_types
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

    it 'assigns to @data_types a list of data types' do
      FieldType.stub(:data_types_list).and_return('a' => 'A', 'b' => 'B', 'c' => 'C')
      get :new, :event_id => @event.id
      assigns[:data_types].should == [['A', 'a'], ['B', 'b'], ['C', 'c']]
    end

    context 'when a data type is not specified' do
      it 'renders the select_data_type template' do
        get :new, :event_id => @event.id
        response.should render_template('select_data_type')
      end
    end

    context 'when a data type is specified' do
      it 'assigns to @field_type a new VisitorFieldType' do
        get :new, :event_id => @event.id, :data_type => 'text'
        field_type = assigns[:field_type]
        field_type.should be_a_new_record
        field_type.should be_a_kind_of(VisitorFieldType)
        @event.visitor_field_types.should include(field_type)
      end

      it 'renders the new template' do
        get :new, :event_id => @event.id, :data_type => 'text'
        response.should render_template('new')
      end
    end
  end

  describe 'GET edit' do
    it 'assigns to @event the given Event' do
      get :edit, :event_id => @event.id, :id => @field_type.id
      assigns[:event].should == @event
    end

    it 'assigns to @field_type the given VisitorFieldType' do
      VisitorFieldType.stub(:find).and_return(@field_type)
      get :edit, :event_id => @event.id, :id => @field_type.id
      assigns[:field_type].should == @field_type
    end

    it 'assigns to @data_types a list of data types' do
      FieldType.stub(:data_types_list).and_return('a' => 'A', 'b' => 'B', 'c' => 'C')
      get :edit, :event_id => @event.id, :id => @field_type.id
      assigns[:data_types].should == [['A', 'a'], ['B', 'b'], ['C', 'c']]
    end

    it 'renders the edit template' do
      get :edit, :event_id => @event.id, :id => @field_type.id
      response.should render_template('edit')
    end
  end

  describe 'GET delete' do
    it 'assigns to @event the given Event' do
      get :delete, :event_id => @event.id, :id => @field_type.id
      assigns[:event].should == @event
    end

    it 'assigns to @field_type the given VisitorFieldType' do
      VisitorFieldType.stub(:find).and_return(@field_type)
      get :delete, :event_id => @event.id, :id => @field_type.id
      assigns[:field_type].should == @field_type
    end

    it 'renders the edit template' do
      get :delete, :event_id => @event.id, :id => @field_type.id
      response.should render_template('delete')
    end
  end

  describe 'POST create' do
    before(:each) do
      VisitorFieldType.stub(:new).and_return(@field_type)
    end

    it 'assigns to @field_type a new VisitorFieldType with the given parameters' do
      @event.visitor_field_types.should_receive(:build).with('foo' => 'bar').and_return(@field_type)
      post :create, :visitor_field_type => {'foo' => 'bar'}, :event_id => @event.id
      assigns[:field_type].should equal(@field_type)
    end

    it 'the new VisitorFieldType belongs to the given Event' do
      post :create, :visitor_field_type => {'foo' => 'bar'}, :event_id => @event.id
      field_type = assigns[:field_type]
      field_type.event.should == @event
      @event.visitor_field_types.should include(field_type)
    end

    it 'saves the VisitorFieldType' do
      @field_type.should_receive(:save)
      post :create, :visitor_field_type => {'foo' => 'bar'}, :event_id => @event.id
    end

    context 'when the VisitorFieldType is successfully saved' do
      before(:each) do
        @field_type.stub(:save).and_return(true)
      end

      it 'sets a flash[:notice] message' do
        post :create, :visitor_field_type => {'foo' => 'bar'}, :event_id => @event.id
        flash[:notice].should == I18n.t('visitor_field_types.create.success')
      end

      it 'redirects to the View Visitor Field Types page' do
        post :create, :visitor_field_type => {'foo' => 'bar'}, :event_id => @event.id
        response.should redirect_to(:action => 'index', :event_id => @event.id)
      end
    end

    context 'when the VisitorFieldType fails to be saved' do
      before(:each) do
        @field_type.stub(:save).and_return(false)
      end

      it 'assigns to @event the given Event' do
        post :create, :visitor_field_type => {'foo' => 'bar'}, :event_id => @event.id
        assigns[:event].should == @event
      end

      it 'assigns to @data_types a list of data types' do
        FieldType.stub(:data_types_list).and_return('a' => 'A', 'b' => 'B', 'c' => 'C')
        post :create, :visitor_field_type => {'foo' => 'bar'}, :event_id => @event.id
        assigns[:data_types].should == [['A', 'a'], ['B', 'b'], ['C', 'c']]
      end

      it 'renders the new template' do
        post :create, :visitor_field_type => {'foo' => 'bar'}, :event_id => @event.id
        response.should render_template('new')
      end
    end
  end

  describe 'PUT update' do
    before(:each) do
      VisitorFieldType.stub(:find).and_return(@field_type)
    end

    it 'assigns to @field_type the given VisitorFieldType' do
      put :update, :visitor_field_type => {}, :event_id => @event.id, :id => @field_type.id
      assigns[:field_type].should equal(@field_type)
    end

    it 'updates the VisitorFieldType' do
      @field_type.should_receive(:update_attributes).with('foo' => 'bar')
      put :update, :visitor_field_type => {'foo' => 'bar'}, :event_id => @event.id, :id => @field_type.id
    end

    context 'when the VisitorFieldType is successfully updated' do
      before(:each) do
        @field_type.stub(:update_attributes).and_return(true)
      end

      it 'sets a flash[:notice] message' do
        put :update, :visitor_field_type => {'foo' => 'bar'}, :event_id => @event.id, :id => @field_type.id
        flash[:notice].should == I18n.t('visitor_field_types.update.success')
      end

      it 'redirects to the View Visitor Field Types page' do
        put :update, :visitor_field_type => {'foo' => 'bar'}, :event_id => @event.id, :id => @field_type.id
        response.should redirect_to(:action => 'index', :event_id => @event.id)
      end
    end

    context 'when the VisitorFieldType fails to be updated' do
      before(:each) do
        @field_type.stub(:update_attributes).and_return(false)
      end

      it 'assigns to @event the given Event' do
        put :update, :visitor_field_type => {'foo' => 'bar'}, :event_id => @event.id, :id => @field_type.id
        assigns[:event].should == @event
      end

      it 'assigns to @data_types a list of data types' do
        FieldType.stub(:data_types_list).and_return('a' => 'A', 'b' => 'B', 'c' => 'C')
        put :update, :visitor_field_type => {'foo' => 'bar'}, :event_id => @event.id, :id => @field_type.id
        assigns[:data_types].should == [['A', 'a'], ['B', 'b'], ['C', 'c']]
      end

      it 'renders the edit template' do
        put :update, :visitor_field_type => {'foo' => 'bar'}, :event_id => @event.id, :id => @field_type.id
        response.should render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    before(:each) do
      VisitorFieldType.stub(:find).and_return(@field_type)
    end

    it 'destroys the VisitorFieldType' do
      @field_type.should_receive(:destroy)
      delete :destroy, :event_id => @event.id, :id => @field_type.id
    end

    it 'sets a flash[:notice] message' do
      delete :destroy, :event_id => @event.id, :id => @field_type.id
      flash[:notice].should == I18n.t('visitor_field_types.destroy.success')
    end

    it 'redirects to the View Visitor Field Types page' do
      delete :destroy, :event_id => @event.id, :id => @field_type.id
      response.should redirect_to(:action => 'index', :event_id => @event.id)
    end
  end
end
