require 'spec_helper'

describe PeopleController do
  before(:each) do
    @person = Factory.create(:person, :ldap_id => 'person')
    @admin = Factory.create(:person, :ldap_id => 'admin', :role => 'administrator')
    RubyCAS::Filter.fake('admin')
  end

  describe 'GET index' do
    it 'assigns to @people a list of all the People sorted by Name' do
      people = Array.new(3) {Person.new}
      Person.stub(:all).and_return(people)
      get :index
      assigns[:people].should == people
    end

    it 'renders the index template' do
      get :index
      response.should render_template('index')
    end
  end

  describe 'GET new' do
    it 'assigns to @person a new Person' do
      get :new
      assigns[:person].should be_a_new_record
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
      Person.stub(:find).and_return(@person)
      get :edit, :id => @person.id
      assigns[:person].should == @person
    end

    it 'renders the edit template' do
      get :edit, :id => @person.id
      response.should render_template('edit')
    end
  end

  describe 'GET delete' do
    it 'assigns to @person the given Person' do
      Person.stub(:find).and_return(@person)
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
        @person.stub(:errors).and_return(:error => 'foo')
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
      Person.stub(:find).and_return(@person)
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
          Person.stub(:find).and_return(@person)
          RubyCAS::Filter.fake(@person.ldap_id)
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
        @person.stub(:errors).and_return(:error => '')
      end

      it 'renders the edit template' do
        put :update, :id => @person.id
        response.should render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    before(:each) do
      Person.stub(:find).and_return(@person)
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
end
