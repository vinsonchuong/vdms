class SettingsController < ApplicationController
  # GET /settings/edit
  def edit
    @settings = Settings.instance
    blank_time = ''..''
    def blank_time.new_record?; true end
    def blank_time.begin; nil end
    def blank_time.end; nil end
    @meeting_times = @settings.meeting_times << blank_time
  end

  # PUT /settings
  def update
    @settings = Settings.instance

    # Hack to address standing bug in Rails 2.3: time_select doesn't work with :include_blank
    # NOT tested in RSpec.
    unless params['settings'].nil? || params['settings']['meeting_times_attributes'].nil?
      params['settings']['meeting_times_attributes'].each_pair do |i, time|
        unless time['end(4i)'].blank? || time['end(5i)'].blank?
          time['end(1i)'] = time['begin(1i)'].blank? ? '2011' : time['begin(1i)']
          time['end(2i)'] = time['begin(2i)'].blank? ? '1' : time['begin(2i)']
          time['end(3i)'] = time['begin(3i)'].blank? ? '1' : time['begin(3i)']
        end
      end
    end

    if @settings.update_attributes(params[:settings])
      redirect_to(edit_settings_url, :notice => t(:success, :scope => [:settings, :update]))
    else
      render :action => 'edit'
    end
  end
end
