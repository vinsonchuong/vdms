require 'spec_helper'

describe VisitorAvailabilitiesController do
  before(:each) do
    @admit = Factory.create(:admit)
    @staff = Factory.create(:staff)
    CASClient::Frameworks::Rails::Filter.fake(@staff.ldap_id)
    Staff.stub(:find).and_return(@staff)
  end

  describe 'GET edit_all' do
    it 'assigns to @schedulable the Visitor' do
      Admit.stub(:find).and_return(@admit)
      get :edit_all, :admit_id => @admit.id
      assigns[:schedulable].should == @admit
    end

    it 'renders the edit_all template' do
      get :edit_all, :admit_id => @admit.id
      response.should render_template('edit_all')
    end
  end

  describe 'PUT update_all' do
    before(:each) do
      Admit.stub(:find).and_return(@admit)
    end

    it 'assigns to @schedulable the Visitor' do
      put :update_all, :admit_id => @admit.id
      assigns[:schedulable].should == @admit
    end

    it 'updates the Admit' do
      @admit.should_receive(:update_attributes).with('foo' => 'bar')
      put :update_all, :admit_id => @admit.id, :admit => {'foo' => 'bar'}
    end

    context 'when the Host is successfully updated' do
      before(:each) do
        @admit.stub(:update_attributes).and_return(true)
      end

      it 'sets a flash[:notice] message' do
        put :update_all, :admit_id => @admit.id, :admit => {'foo' => 'bar'}
        flash[:notice].should == I18n.t('people.admits.update.success')
      end

      it 'redirects to the Edit All Availabilities Page' do
        put :update_all, :admit_id => @admit.id, :admit => {'foo' => 'bar'}
        response.should redirect_to(:controller => 'visitor_availabilities', :action => 'edit_all', :admit_id => @admit.id)
      end
    end

    context 'the Host fails to be saved' do
      before(:each) do
        @admit.stub(:update_attributes).and_return(false)
      end

      it 'renders the Edit All Availabilities Page' do
        put :update_all, :admit_id => @admit.id, :admit => {'foo' => 'bar'}
        response.should render_template('edit_all')
      end
    end
  end
end

