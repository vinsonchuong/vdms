require 'spec_helper'

describe HostAvailabilitiesController do
  before(:each) do
    @faculty_instance = Factory.create(:faculty)
    @staff = Factory.create(:staff)
    CASClient::Frameworks::Rails::Filter.fake(@staff.ldap_id)
    Staff.stub(:find).and_return(@staff)
  end

  describe 'GET edit_all' do
    it 'assigns to @schedulable the Host' do
      Faculty.stub(:find).and_return(@faculty_instance)
      get :edit_all, :faculty_instance_id => @faculty_instance.id
      assigns[:schedulable].should == @faculty_instance
    end

    it 'renders the edit_all template' do
      get :edit_all, :faculty_instance_id => @faculty_instance.id
      response.should render_template('edit_all')
    end
  end

  describe 'PUT update_all' do
    before(:each) do
      Faculty.stub(:find).and_return(@faculty_instance)
    end

    it 'assigns to @schedulable the Host' do
      put :update_all, :faculty_instance_id => @faculty_instance.id
      assigns[:schedulable].should == @faculty_instance
    end

    it 'updates the Host' do
      @faculty_instance.should_receive(:update_attributes).with('foo' => 'bar')
      put :update_all, :faculty_instance_id => @faculty_instance.id, :faculty => {'foo' => 'bar'}
    end

    context 'when the Host is successfully updated' do
      before(:each) do
        @faculty_instance.stub(:update_attributes).and_return(true)
      end

      it 'sets a flash[:notice] message' do
        put :update_all, :faculty_instance_id => @faculty_instance.id, :faculty => {'foo' => 'bar'}
        flash[:notice].should == I18n.t('people.faculty.update.success')
      end

      it 'redirects to the Edit All Availabilities Page' do
        put :update_all, :faculty_instance_id => @faculty_instance.id, :faculty => {'foo' => 'bar'}
        response.should redirect_to(:controller => 'host_availabilities', :action => 'edit_all', :faculty_instance_id => @faculty_instance.id)
      end
    end

    context 'the Host fails to be saved' do
      before(:each) do
        @faculty_instance.stub(:update_attributes).and_return(false)
      end

      it 'renders the Edit All Availabilities Page' do
        put :update_all, :faculty_instance_id => @faculty_instance.id, :faculty => {'foo' => 'bar'}
        response.should render_template('edit_all')
      end
    end
  end
end
