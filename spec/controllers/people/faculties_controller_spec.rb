require 'spec_helper'

describe FacultiesController do
  before(:each) do
    @staff = Factory.create(:staff)
    @faculty = Factory.create(:faculty)
  end

  describe 'GET index' do
    context 'when not signed in' do
      it 'redirects to the CalNet sign in page' do
        get :index
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(faculties_url)}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(@staff.calnet_id)
      end

      it 'assigns to @faculties a list of all the Faculty' do
        faculties = Array.new(3) {Faculty.new}
        Faculty.stub(:find).and_return(faculties)
        get :index
        assigns[:faculties].should == faculties
      end

      it 'renders the index template' do
        get :index
        response.should render_template('index')
      end
    end

    context 'when signed in as a Peer Advisor'

    context 'when signed in as a Faculty'
  end

  describe 'GET new' do
    context 'when not signed in' do
      it 'redirects to the CalNet sign in page' do
        get :new
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(new_faculty_url)}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(@staff.calnet_id)
      end

      it 'assigns to @faculty a new Faculty' do
        get :new
        assigns[:faculty].should be_a_new_record
      end

      it 'renders the new template' do
        get :new
        response.should render_template('new')
      end
    end

    context 'when signed in as a Peer Advisor'

    context 'when signed in as a Faculty'
  end

  describe 'GET upload' do
    context 'when not signed in' do
      it 'redirects to the CalNet sign in page' do
        get :upload
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(upload_faculties_url)}")
      end
    end

    context 'when signed in as a Staff'

    context 'when signed in as a Peer Advisor'

    context 'when signed in as a Faculty'
  end

  describe 'GET edit' do
    context 'when not signed in' do
      it 'redirects to the CalNet sign in page' do
        get :edit, :id => @faculty.id
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(edit_faculty_url(@faculty.id))}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(@staff.calnet_id)
      end
  
      it 'assigns to @faculty the given Faculty' do
        Faculty.stub(:find).and_return(@faculty)
        get :edit, :id => @faculty.id
        assigns[:faculty].should == @faculty
      end
 
      it 'renders the edit template' do
        get :edit, :id => @faculty.id
        response.should render_template('edit')
      end
    end

    context 'when signed in as a Peer Advisor'

    context 'when signed in as a Faculty'
  end

  describe 'GET delete' do
    context 'when not signed in' do
      it 'redirects to the CalNet sign in page' do
        get :delete, :id => @faculty.id
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(delete_faculty_url(@faculty.id))}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(@staff.calnet_id)
      end

      it 'assigns to @faculty the given Faculty' do
        Faculty.stub(:find).and_return(@faculty)
        get :delete, :id => @faculty.id
        assigns[:faculty].should == @faculty
      end
 
      it 'renders the delete template' do
        get :delete, :id => @faculty.id
        response.should render_template('delete')
      end
    end

    context 'when signed in as a Peer Advisor'

    context 'when signed in as a Faculty'
  end

  describe 'POST create' do
    context 'when not signed in' do
      it 'redirects to the CalNet sign in page' do
        post :create
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(faculties_url)}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        Faculty.stub(:new).and_return(@faculty)
        CASClient::Frameworks::Rails::Filter.fake(@staff.calnet_id)
      end

      it 'assigns to @faculty a new Faculty with the given parameters' do
        Faculty.should_receive(:new).with('foo' => 'bar').and_return(@faculty)
        post :create, :faculty => {'foo' => 'bar'}
        assigns[:faculty].should equal(@faculty)
      end
 
      it 'saves the Faculty' do
        @faculty.should_receive(:save)
        post :create
      end

      context 'when the Faculty is successfully saved' do
        before(:each) do
          @faculty.stub(:save).and_return(true)
        end

        it 'sets a flash[:notice] message' do
          post :create
          flash[:notice].should == 'Faculty was successfully added.'
        end

        it 'redirects to the View Faculty page' do
          post :create
          response.should redirect_to(:action => 'index')
        end
      end

      context 'when the Faculty fails to be saved' do
        before(:each) do
          @faculty.stub(:save).and_return(false)
        end

        it 'renders the new template' do
          post :create
          response.should render_template('new')
        end
      end
    end

    context 'when signed in as a Peer Advisor'

    context 'when signed in as a Faculty'
  end

  describe 'POST import' do
    context 'when not signed in' do
      it 'redirects to the CalNet sign in page' do
        post :import
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(import_faculties_url)}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        @csv_text = 'text'
        @faculties = [Faculty.new, Faculty.new, Faculty.new]
        Faculty.stub(:new_from_csv).and_return(@faculties)
        CASClient::Frameworks::Rails::Filter.fake(@staff.calnet_id)
      end

      it 'assigns to @staff a collection of Faculties built from the attributes in each row' do
        Faculty.should_receive(:new_from_csv).with(@csv_text).and_return(@faculties)
        post :import, :csv_file => @csv_text
        assigns[:faculties].should equal(@faculties)
      end

      context 'when the Faculties are all valid' do
        before(:each) do
          @faculties.each {|s| s.stub(:valid?).and_return(true)}
        end

        it 'sets a flash[:notice] message' do
          post :import, :csv_file => @csv_text
          flash[:notice].should == 'Faculties were successfully imported.'
        end

        it 'redirects to the View Faculty page' do
          post :import, :csv_file => @csv_text
          response.should redirect_to(:action => 'index')
        end
      end

      context 'when not all of the Faculties are valid' do
        before(:each) do
          @faculties.first.stub(:valid?).and_return(false)
        end

        it 'renders the upload template' do
          post :import, :csv_file => @csv_text
          response.should render_template('upload')
        end
      end
    end

    context 'when signed in as a Peer Advisor'

    context 'when signed in as a Faculty'
  end

  describe 'PUT update' do
    context 'when not signed in' do
      it 'redirects to the CalNet sign in page' do
        put :update, :id => @faculty.id
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(faculty_url(@faculty.id))}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        Faculty.stub(:find).and_return(@faculty)
        CASClient::Frameworks::Rails::Filter.fake(@staff.calnet_id)
      end

      it 'assigns to @faculty the given Faculty' do
        Faculty.should_receive(:find).with(@faculty.id.to_s).and_return(@faculty)
        put :update, :id => @faculty.id
        assigns[:faculty].should equal(@faculty)
      end

      it 'updates the Faculty' do
        @faculty.should_receive(:update_attributes).with('foo' => 'bar')
        put :update, :id => @faculty.id, :faculty => {'foo' => 'bar'}
      end

      context 'when the Faculty is successfully updated' do
        before(:each) do
          @faculty.stub(:update_attributes).and_return(true)
        end
  
        it 'sets a flash[:notice] message' do
          put :update, :id => @faculty.id
          flash[:notice].should == 'Faculty was successfully updated.'
        end

        it 'redirects to the View Faculty page' do
          put :update, :id => @faculty.id
          response.should redirect_to(:action => 'index')
        end
      end

      context 'when the Faculty fails to be saved' do
        before(:each) do
          @faculty.stub(:update_attributes).and_return(false)
        end

        it 'renders the edit template' do
          put :update, :id => @faculty.id
          response.should render_template('edit')
        end
      end
    end

    context 'when signed in as a Peer Advisor'

    context 'when signed in as a Faculty'
  end

  describe 'DELETE destroy' do
    context 'when not signed in' do
      it 'redirects to the CalNet sign in page' do
        delete :destroy, :id => @faculty.id
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(faculty_url(@faculty.id))}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        Faculty.stub(:find).and_return(@faculty)
        CASClient::Frameworks::Rails::Filter.fake(@staff.calnet_id)
      end

      it 'assigns to @faculty the given Faculty' do
        Faculty.should_receive(:find).with(@faculty.id.to_s).and_return(@faculty)
        delete :destroy, :id => @faculty.id
        assigns[:faculty].should equal(@faculty)
      end

      it 'destroys the Faculty' do
        @faculty.should_receive(:destroy)
        delete :destroy, :id => @faculty.id
      end

      it 'sets a flash[:notice] message' do
        delete :destroy, :id => @faculty.id
        flash[:notice].should == 'Faculty was removed.'
      end

      it 'redirects to the View Faculty page' do
        delete :destroy, :id => @faculty.id
        response.should redirect_to(:action => 'index')
      end
    end

    context 'when signed in as a Peer Advisor'

    context 'when signed in as a Faculty'
  end
end
