require 'spec_helper'

describe PeopleController do
  before(:each) do
    @person = Factory.create(:person, :ldap_id => 'person')
    @admin = Factory.create(:person, :ldap_id => 'admin', :role => 'administrator')
    CASClient::Frameworks::Rails::Filter.fake('admin')
  end

  describe 'GET index' do
    it 'assigns to @people a list of all the People sorted by Name' do
      people = Array.new(3) {Person.new}
      Person.stub(:find).and_return(@admin, people)
      get :index
      assigns[:people].should == people
    end

    it 'renders the index template' do
      get :index
      response.should render_template('index')
    end
  end

  describe 'GET delete_all' do
    it 'renders the delete_all template' do
      get :delete_all
      response.should render_template('delete_all')
    end
  end

  describe 'GET new' do
    it 'assigns to @person a new Person' do
      get :new
      assigns[:person].should be_a_new_record
    end

    it 'assigns to @areas a list of the Areas' do
      Person.stub(:areas).and_return('A1' => 'Area 1', 'A2' => 'Area 2', 'A3' => 'Area 3')
      get :new
      assigns[:areas].should == [['Area 1', 'A1'], ['Area 2', 'A2'], ['Area 3', 'A3']]
    end

    it 'assigns to @divisions a list of the Division names' do
      Person.stub(:divisions).and_return('D1' => 'Division 1', 'D2' => 'Division 2', 'D3' => 'Division 3')
      get :new
      assigns[:divisions].should == [['Division 1', 'D1'], ['Division 2', 'D2'], ['Division 3', 'D3']]
    end

    it 'renders the new template' do
      get :new
      response.should render_template('new')
    end
  end

  describe 'GET upload' do
    it 'renders the upload template' do
      get :upload
      response.should render_template('upload')
    end
  end

  describe 'GET edit' do
    it 'assigns to @person the given Person' do
      Person.stub(:find).and_return(@admin, @person)
      get :edit, :id => @person.id
      assigns[:person].should == @person
    end

    it 'assigns to @areas a list of the Areas' do
      Person.stub(:areas).and_return('A1' => 'Area 1', 'A2' => 'Area 2', 'A3' => 'Area 3')
      get :edit, :id => @person.id
      assigns[:areas].should == [['Area 1', 'A1'], ['Area 2', 'A2'], ['Area 3', 'A3']]
    end

    it 'assigns to @divisions a list of the Division names' do
      Person.stub(:divisions).and_return('D1' => 'Division 1', 'D2' => 'Division 2', 'D3' => 'Division 3')
      get :edit, :id => @person.id
      assigns[:divisions].should == [['Division 1', 'D1'], ['Division 2', 'D2'], ['Division 3', 'D3']]
    end

    it 'renders the edit template' do
      get :edit, :id => @person.id
      response.should render_template('edit')
    end
  end

  describe 'GET delete' do
    it 'assigns to @person the given Person' do
      Person.stub(:find).and_return(@admin, @person)
      get :delete, :id => @person.id
      assigns[:person].should == @person
    end

    it 'renders the delete template' do
      get :delete, :id => @person.id
      response.should render_template('delete')
    end
  end

  describe 'POST create' do
    before(:each) do
      Person.stub(:new).and_return(@person)
    end

    it 'assigns to @person a new Person with the given parameters' do
      Person.should_receive(:new).with('foo' => 'bar').and_return(@person)
      post :create, :person => {'foo' => 'bar'}
      assigns[:person].should equal(@person)
    end

    it 'saves the Person' do
      @person.should_receive(:save)
      post :create, :person => {'foo' => 'bar'}
    end

    context 'when the Person is successfully saved' do
      before(:each) do
        @person.stub(:save).and_return(true)
      end

      it 'sets a flash[:notice] message' do
        post :create, :person => {'foo' => 'bar'}
        flash[:notice].should == I18n.t('people.create.success')
      end

      it 'redirects to the View People page' do
        post :create, :person => {'foo' => 'bar'}
        response.should redirect_to(:action => 'index')
      end
    end

    context 'when the Person fails to be saved' do
      before(:each) do
        @person.stub(:save).and_return(false)
      end

      it 'assigns to @areas a list of the Areas' do
        Person.stub(:areas).and_return('A1' => 'Area 1', 'A2' => 'Area 2', 'A3' => 'Area 3')
        post :create, :person => {'foo' => 'bar'}
        assigns[:areas].should == [['Area 1', 'A1'], ['Area 2', 'A2'], ['Area 3', 'A3']]
      end

      it 'assigns to @divisions a list of the Division names' do
        Person.stub(:divisions).and_return('D1' => 'Division 1', 'D2' => 'Division 2', 'D3' => 'Division 3')
        post :create, :person => {'foo' => 'bar'}
        assigns[:divisions].should == [['Division 1', 'D1'], ['Division 2', 'D2'], ['Division 3', 'D3']]
      end

      it 'renders the new template' do
        post :create
        response.should render_template('new')
      end
    end
  end

  describe 'POST import' do
    before(:each) do
      @csv_text = 'text'
      @people = Array.new(3) {Person.new}
      Person.stub(:new_from_csv).and_return(@people)
    end

    it 'assigns to @people a collection of People built from the attributes in each row' do
      Person.should_receive(:new_from_csv).with(@csv_text).and_return(@people)
      post :import, :csv_file => @csv_text
      assigns[:people].should == @people
    end

    context 'when the People are all valid' do
      before(:each) do
        @people.each {|p| p.stub(:valid?).and_return(true)}
      end

      it 'sets a flash[:notice] message' do
        post :import, :csv_file => @csv_text
        flash[:notice].should == I18n.t('people.import.success')
      end

      it 'redirects to the View People page' do
        post :import, :csv_file => @csv_text
        response.should redirect_to(:action => 'index')
      end
    end

    context 'when not all of the People are valid' do
      before(:each) do
        @people.first.stub(:valid?).and_return(false)
      end

      it 'renders the upload template' do
        post :import, :csv_file => @csv_text
        response.should render_template('upload')
      end
    end
  end

  describe 'PUT update' do
    before(:each) do
      Person.stub(:find).and_return(@admin, @person)
    end

    it 'assigns to @person the given Person' do
      put :update, :id => @person.id
      assigns[:person].should == @person
    end

    it 'updates the person' do
      @person.should_receive(:update_attributes).with('foo' => 'bar')
      put :update, :id => @person.id, :person => {'foo' => 'bar'}
    end

    context 'when the Person is successfully updated' do
      before(:each) do
        @person.stub(:update_attributes).and_return(true)
      end

      context 'when signed in as an administrator' do
        it 'sets a flash[:notice] message' do
          put :update, :id => @person.id
          flash[:notice].should == I18n.t('people.update.success')
        end

        it 'redirects to the View People page' do
          put :update, :id => @person.id
          response.should redirect_to(:action => 'index')
        end
      end

      context 'when signed in as the given Person' do
        before(:each) do
          Person.stub(:find).and_return(@person, @person)
          CASClient::Frameworks::Rails::Filter.fake(@person.ldap_id)
        end

        it 'sets a flash[:notice] message' do
          put :update, :id => @person.id
          flash[:notice].should == I18n.t('people.update.success_alt')
        end

        it 'redirects to the View People page' do
          put :update, :id => @person.id
          response.should redirect_to(root_url)
        end
      end
    end

    context 'when the Person fails to be saved' do
      before(:each) do
        @person.stub(:update_attributes).and_return(false)
      end

      it 'assigns to @areas a list of the Areas' do
        Person.stub(:areas).and_return('A1' => 'Area 1', 'A2' => 'Area 2', 'A3' => 'Area 3')
        put :update, :id => @person.id
        assigns[:areas].should == [['Area 1', 'A1'], ['Area 2', 'A2'], ['Area 3', 'A3']]
      end

      it 'assigns to @divisions a list of the Division names' do
        Person.stub(:divisions).and_return('D1' => 'Division 1', 'D2' => 'Division 2', 'D3' => 'Division 3')
        put :update, :id => @person.id
        assigns[:divisions].should == [['Division 1', 'D1'], ['Division 2', 'D2'], ['Division 3', 'D3']]
      end

      it 'renders the edit template' do
        put :update, :id => @person.id
        response.should render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    before(:each) do
      Person.stub(:find).and_return(@admin, @person)
    end

    it 'destroys the Person' do
      @person.should_receive(:destroy)
      delete :destroy, :id => @person.id
    end

    it 'sets a flash[:notice] message' do
      delete :destroy, :id => @person.id
      flash[:notice].should == I18n.t('people.destroy.success')
    end

    it 'redirects to the View People page' do
      delete :destroy, :id => @person.id
      response.should redirect_to(:action => 'index')
    end
  end

  describe 'DELETE destroy_all' do
    it 'removes all People' do
      people = Array.new(3) do
        person = Person.new
        person.should_receive(:destroy)
        person
      end
      Person.stub(:find).and_return(@admin, people)
      delete :destroy_all
    end

    it 'sets a flash[:notice] message' do
      delete :destroy_all
      flash[:notice].should == I18n.t('people.destroy_all.success')
    end

    it 'redirects to the View People page' do
      delete :destroy_all
      response.should redirect_to(:action => 'index')
    end
  end
end
