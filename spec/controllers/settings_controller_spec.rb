require 'spec_helper'

describe SettingsController do
  before(:each) do
    @settings = Settings.instance
    Settings.stub(:instance).and_return(@settings)
  end

  describe 'GET edit' do
    it 'assigns to @settings the Settings singleton' do
      get :edit
      assigns[:settings].should equal(@settings)
    end

    it 'renders the edit template' do
      get :edit
      response.should render_template('edit')
    end
  end

  describe 'PUT update' do
    it 'assigns to @settings the Settings singleton' do
      put :update
      assigns[:settings].should equal(@settings)
    end

    it 'updates the settings' do
      @settings.should_receive(:update_attributes).with('key' => 'value')
      put :update, :settings => {'key' => 'value'}
    end

    context 'when the settings are successfully updated' do
      before(:each) do
        @settings.stub(:update_attributes).and_return(true)
      end

      it 'sets a flash[:notice] message' do
        put :update
        flash[:notice].should == I18n.t('settings.update.success')
      end

      it 'redirects to the edit settings page' do
        put :update
        response.should redirect_to(:action => 'edit')
      end
    end

    context 'when the settings fail to be updated' do
      before(:each) do
        @settings.stub(:update_attributes).and_return(false)
      end

      it 'renders the edit template' do
        put :update
        response.should render_template('edit')
      end
    end
  end
end
