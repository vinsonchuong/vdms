require 'spec_helper'

describe SettingsController do
  before(:each) do
    @staff = Factory.create(:staff)
    @peer_advisor = Factory.create(:peer_advisor)
    @faculty = Factory.create(:faculty)
    @settings = Settings.instance
    Settings.stub(:instance).and_return(@settings)
  end

  describe 'GET edit' do
    context 'when not signed in' do
      it 'redirects to the CalNet sign in page' do
        get :edit
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(edit_settings_url)}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(@staff.calnet_id)
      end

      it 'assigns to @settings the Settings singleton' do
        get :edit
        assigns[:settings].should equal(@settings)
      end

      it 'builds a new AvailableTime for each division' do
        divisions = Array.new(3) do |i|
          Division.new(:name => "Division #{i}") do |division|
            division.available_times.should_receive(:build)
          end
        end
        @settings.stub(:divisions).and_return(divisions)
        get :edit
      end

      it 'renders the edit template' do
        get :edit
        response.should render_template('edit')
      end
    end

    context 'when signed in as a Peer Advisor' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(@peer_advisor.calnet_id)
      end

      it 'redirects to the CalNet sign in page' do
        pending
        get :edit
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(edit_settings_url)}")
      end
    end

    context 'when signed in as a Faculty' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(@faculty.calnet_id)
      end

      it 'redirects to the CalNet sign in page' do
        pending
        get :edit
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(edit_settings_url)}")
      end
    end
  end

  describe 'PUT update' do
    context 'when not signed in' do
      it 'redirects to the CalNet sign in page' do
        put :update
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(settings_url)}")
      end
    end

    context 'when signed in as a Staff' do
      before(:each) do
        @settings = Settings.instance
        Settings.stub(:instance).and_return(@settings)
        CASClient::Frameworks::Rails::Filter.fake(@staff.calnet_id)
      end

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
          flash[:notice].should == 'Settings were successfully updated.'
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

    context 'when signed in as a Peer Advisor' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(@peer_advisor.calnet_id)
      end

      it 'redirects to the CalNet sign in page' do
        pending
        put :update
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(settings_url)}")
      end
    end

    context 'when signed in as a Faculty' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(@faculty.calnet_id)
      end

      it 'redirects to the CalNet sign in page' do
        pending
        put :update
        response.should redirect_to("#{CASClient::Frameworks::Rails::Filter.config[:login_url]}?service=#{CGI.escape(settings_url)}")
      end
    end
  end
end
