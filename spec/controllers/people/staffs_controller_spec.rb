require 'spec_helper'

describe StaffsController do
  before(:each) do
    @staff = Factory.create(:staff)
  end

  describe 'GET index' do
    context 'when not signed in' do
      it 'redirects to the CalNet sign in page' do
        get :index
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(staffs_url)}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(@staff.calnet_id)
      end

      it 'assigns to @staffs a list of all the Staff' do
        staffs = Array.new(3) {Staff.new}
        Staff.stub(:find).and_return(staffs)
        get :index
        assigns[:staffs].should == staffs
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
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(new_staff_url)}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(@staff.calnet_id)
      end

      it 'assigns to @staff a new Staff' do
        get :new
        assigns[:staff].should be_a_new_record
      end

      it 'renders the new template' do
        get :new
        response.should render_template('new')
      end
    end

    context 'when signed in as a Peer Advisor'

    context 'when signed in as a Faculty'
  end

  describe 'GET import' do
    context 'when not signed in' do
      it 'redirects to the CalNet sign in page' do
        get :import
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(import_staffs_url)}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(@staff.calnet_id)
      end
    end

    context 'when signed in as a Peer Advisor'

    context 'when signed in as a Faculty'
  end

  describe 'GET edit' do
    context 'when not signed in' do
      it 'redirects to the CalNet sign in page' do
        get :edit, :id => @staff.id
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(edit_staff_url(@staff.id))}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(@staff.calnet_id)
      end
  
      it 'assigns to @staff the given Staff' do
        Staff.stub(:find).and_return(@staff)
        get :edit, :id => @staff.id
        assigns[:staff].should == @staff
      end
 
      it 'renders the edit template' do
        get :edit, :id => @staff.id
        response.should render_template('edit')
      end
    end

    context 'when signed in as a Peer Advisor'

    context 'when signed in as a Faculty'
  end

  describe 'GET delete' do
    context 'when not signed in' do
      it 'redirects to the CalNet sign in page' do
        get :delete, :id => @staff.id
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(delete_staff_url(@staff.id))}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(@staff.calnet_id)
      end

      it 'assigns to @staff the given Staff' do
        Staff.stub(:find).and_return(@staff)
        get :delete, :id => @staff.id
        assigns[:staff].should == @staff
      end
 
      it 'renders the delete template' do
        get :delete, :id => @staff.id
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
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(staffs_url)}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        Staff.stub(:new).and_return(@staff)
        CASClient::Frameworks::Rails::Filter.fake(@staff.calnet_id)
      end

      it 'assigns to @staff a new Staff with the given parameters' do
        Staff.should_receive(:new).with('foo' => 'bar').and_return(@staff)
        post :create, :staff => {'foo' => 'bar'}
        assigns[:staff].should equal(@staff)
      end
 
      it 'saves the Staff' do
        @staff.should_receive(:save)
        post :create
      end

      context 'when the Staff is successfully saved' do
        before(:each) do
          @staff.stub(:save).and_return(true)
        end

        it 'sets a flash[:notice] message' do
          post :create
          flash[:notice].should == 'Staff was successfully added.'
        end

        it 'redirects to the View Staff page' do
          post :create
          response.should redirect_to(:action => 'index')
        end
      end

      context 'when the Staff fails to be saved' do
        before(:each) do
          @staff.stub(:save).and_return(false)
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

  describe 'PUT update' do
    context 'when not signed in' do
      it 'redirects to the CalNet sign in page' do
        put :update, :id => @staff.id
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(staff_url(@staff.id))}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        Staff.stub(:find).and_return(@staff)
        CASClient::Frameworks::Rails::Filter.fake(@staff.calnet_id)
      end

      it 'assigns to @staff the given Staff' do
        Staff.should_receive(:find).with(@staff.id.to_s).and_return(@staff)
        put :update, :id => @staff.id
        assigns[:staff].should equal(@staff)
      end

      it 'updates the Staff' do
        @staff.should_receive(:update_attributes).with('foo' => 'bar')
        put :update, :id => @staff.id, :staff => {'foo' => 'bar'}
      end

      context 'when the Staff is successfully updated' do
        before(:each) do
          @staff.stub(:update_attributes).and_return(true)
        end
  
        it 'sets a flash[:notice] message' do
          put :update, :id => @staff.id
          flash[:notice].should == 'Staff was successfully updated.'
        end

        it 'redirects to the View Staff page' do
          put :update, :id => @staff.id
          response.should redirect_to(:action => 'index')
        end
      end

      context 'when the Staff fails to be saved' do
        before(:each) do
          @staff.stub(:update_attributes).and_return(false)
        end

        it 'renders the edit template' do
          put :update, :id => @staff.id
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
        delete :destroy, :id => @staff.id
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(staff_url(@staff.id))}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        Staff.stub(:find).and_return(@staff)
        CASClient::Frameworks::Rails::Filter.fake(@staff.calnet_id)
      end

      it 'assigns to @staff the given Staff' do
        Staff.should_receive(:find).with(@staff.id.to_s).and_return(@staff)
        delete :destroy, :id => @staff.id
        assigns[:staff].should equal(@staff)
      end

      it 'destroys the Staff' do
        @staff.should_receive(:destroy)
        delete :destroy, :id => @staff.id
      end

      it 'sets a flash[:notice] message' do
        delete :destroy, :id => @staff.id
        flash[:notice].should == 'Staff was removed.'
      end

      it 'redirects to the View Staff page' do
        delete :destroy, :id => @staff.id
        response.should redirect_to(:action => 'index')
      end
    end

    context 'when signed in as a Peer Advisor'

    context 'when signed in as a Faculty'
  end
end
