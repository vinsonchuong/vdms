require 'spec_helper'

describe AdmitsController do
  before(:each) do
    @staff = Factory.create(:staff)
    @admit = Factory.create(:admit)
  end

  describe 'GET index' do
    context 'when not signed in' do
      it 'redirects to the CalNet sign in page' do
        get :index
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(admits_url)}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(@staff.calnet_id)
      end

      it 'assigns to @admits a list of all the Admits' do
        admits = Array.new(3) {Admit.new}
        Admit.stub(:find).and_return(admits)
        get :index
        assigns[:admits].should == admits
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
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(new_admit_url)}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(@staff.calnet_id)
      end

      it 'assigns to @admit a new Admit' do
        get :new
        assigns[:admit].should be_a_new_record
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
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(upload_admits_url)}")
      end
    end

    context 'when signed in as a Staff'

    context 'when signed in as a Peer Advisor'

    context 'when signed in as a Faculty'
  end

  describe 'GET edit' do
    context 'when not signed in' do
      it 'redirects to the CalNet sign in page' do
        get :edit, :id => @admit.id
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(edit_admit_url(@admit.id))}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(@staff.calnet_id)
      end
  
      it 'assigns to @admit the given Admit' do
        Admit.stub(:find).and_return(@admit)
        get :edit, :id => @admit.id
        assigns[:admit].should == @admit
      end
 
      it 'renders the edit template' do
        get :edit, :id => @admit.id
        response.should render_template('edit')
      end
    end

    context 'when signed in as a Peer Advisor'

    context 'when signed in as a Faculty'
  end

  describe 'GET delete' do
    context 'when not signed in' do
      it 'redirects to the CalNet sign in page' do
        get :delete, :id => @admit.id
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(delete_admit_url(@admit.id))}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(@staff.calnet_id)
      end

      it 'assigns to @admit the given Admit' do
        Admit.stub(:find).and_return(@admit)
        get :delete, :id => @admit.id
        assigns[:admit].should == @admit
      end
 
      it 'renders the delete template' do
        get :delete, :id => @admit.id
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
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(admits_url)}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        Admit.stub(:new).and_return(@admit)
        CASClient::Frameworks::Rails::Filter.fake(@staff.calnet_id)
      end

      it 'assigns to @admit a new Admit with the given parameters' do
        Admit.should_receive(:new).with('foo' => 'bar').and_return(@admit)
        post :create, :admit => {'foo' => 'bar'}
        assigns[:admit].should equal(@admit)
      end
 
      it 'saves the Admit' do
        @admit.should_receive(:save)
        post :create
      end

      context 'when the Admit is successfully saved' do
        before(:each) do
          @admit.stub(:save).and_return(true)
        end

        it 'sets a flash[:notice] message' do
          post :create
          flash[:notice].should == 'Admit was successfully added.'
        end

        it 'redirects to the View Admits page' do
          post :create
          response.should redirect_to(:action => 'index')
        end
      end

      context 'when the Admit fails to be saved' do
        before(:each) do
          @admit.stub(:save).and_return(false)
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
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(import_admits_url)}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        @csv_text = 'text'
        @admits = [Admit.new, Admit.new, Admit.new]
        Admit.stub(:new_from_csv).and_return(@admits)
        CASClient::Frameworks::Rails::Filter.fake(@staff.calnet_id)
      end

      it 'assigns to @admits a collection of Admits built from the attributes in each row' do
        Admit.should_receive(:new_from_csv).with(@csv_text).and_return(@admits)
        post :import, :csv_file => @csv_text
        assigns[:admits].should equal(@admits)
      end

      context 'when the Staffs are all valid' do
        before(:each) do
          @admits.each {|s| s.stub(:valid?).and_return(true)}
        end

        it 'sets a flash[:notice] message' do
          post :import, :csv_file => @csv_text
          flash[:notice].should == 'Admits were successfully imported.'
        end

        it 'redirects to the View Admit page' do
          post :import, :csv_file => @csv_text
          response.should redirect_to(:action => 'index')
        end
      end

      context 'when not all of the Admits are valid' do
        before(:each) do
          @admits.first.stub(:valid?).and_return(false)
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
        put :update, :id => @admit.id
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(admit_url(@admit.id))}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        Admit.stub(:find).and_return(@admit)
        CASClient::Frameworks::Rails::Filter.fake(@staff.calnet_id)
      end

      it 'assigns to @admit the given Admit' do
        Admit.should_receive(:find).with(@admit.id.to_s).and_return(@admit)
        put :update, :id => @admit.id
        assigns[:admit].should equal(@admit)
      end

      it 'updates the Admit' do
        @admit.should_receive(:update_attributes).with('foo' => 'bar')
        put :update, :id => @admit.id, :admit => {'foo' => 'bar'}
      end

      context 'when the Admit is successfully updated' do
        before(:each) do
          @admit.stub(:update_attributes).and_return(true)
        end
  
        it 'sets a flash[:notice] message' do
          put :update, :id => @admit.id
          flash[:notice].should == 'Admit was successfully updated.'
        end

        it 'redirects to the View Admit page' do
          put :update, :id => @admit.id
          response.should redirect_to(:action => 'index')
        end
      end

      context 'when the Admit fails to be saved' do
        before(:each) do
          @admit.stub(:update_attributes).and_return(false)
        end

        it 'renders the edit template' do
          put :update, :id => @admit.id
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
        delete :destroy, :id => @admit.id
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(admit_url(@admit.id))}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        Admit.stub(:find).and_return(@admit)
        CASClient::Frameworks::Rails::Filter.fake(@staff.calnet_id)
      end

      it 'assigns to @admit the given Admit' do
        Admit.should_receive(:find).with(@admit.id.to_s).and_return(@admit)
        delete :destroy, :id => @admit.id
        assigns[:admit].should equal(@admit)
      end

      it 'destroys the Admit' do
        @admit.should_receive(:destroy)
        delete :destroy, :id => @admit.id
      end

      it 'sets a flash[:notice] message' do
        delete :destroy, :id => @admit.id
        flash[:notice].should == 'Admit was removed.'
      end

      it 'redirects to the View Admits page' do
        delete :destroy, :id => @admit.id
        response.should redirect_to(:action => 'index')
      end
    end

    context 'when signed in as a Peer Advisor'

    context 'when signed in as a Faculty'
  end
end
