require 'spec_helper'

describe HostAvailabilitiesController do
  before(:each) do
    @host = Factory.create(:host)
    @staff = Factory.create(:staff)
    CASClient::Frameworks::Rails::Filter.fake(@staff.ldap_id)
    Staff.stub(:find).and_return(@staff)
  end

  describe 'GET edit_all' do
    it 'assigns to @schedulable the Host' do
      Host.stub(:find).and_return(@host)
      get :edit_all, :host_id => @host.id
      assigns[:schedulable].should == @host
    end

    it 'renders the edit_all template' do
      get :edit_all, :host_id => @host.id
      response.should render_template('edit_all')
    end
  end

  describe 'PUT update_all' do
    before(:each) do
      Host.stub(:find).and_return(@host)
    end

    it 'assigns to @schedulable the Host' do
      put :update_all, :host_id => @host.id
      assigns[:schedulable].should == @host
    end

    it 'updates the Host' do
      @host.should_receive(:update_attributes).with('foo' => 'bar')
      put :update_all, :host_id => @host.id, :host => {'foo' => 'bar'}
    end

    context 'when the Host is successfully updated' do
      before(:each) do
        @host.stub(:update_attributes).and_return(true)
      end

      it 'sets a flash[:notice] message' do
        put :update_all, :host_id => @host.id, :host => {'foo' => 'bar'}
        flash[:notice].should == I18n.t('hosts.update.success')
      end

      it 'redirects to the Edit All Availabilities Page' do
        put :update_all, :host_id => @host.id, :host => {'foo' => 'bar'}
        response.should redirect_to(:controller => 'host_availabilities', :action => 'edit_all', :host_id => @host.id)
      end
    end

    context 'the Host fails to be saved' do
      before(:each) do
        @host.stub(:update_attributes).and_return(false)
      end

      it 'renders the Edit All Availabilities Page' do
        put :update_all, :host_id => @host.id, :host => {'foo' => 'bar'}
        response.should render_template('edit_all')
      end
    end
  end
end
