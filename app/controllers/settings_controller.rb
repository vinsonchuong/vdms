class SettingsController < ApplicationController
  # GET /settings/edit
  def edit
    @settings = Settings.instance
    @settings.divisions.each {|d| d.available_times.build}
  end

  # PUT /settings
  def update
    @settings = Settings.instance
    unless params['settings'].nil? || params['settings']['divisions_attributes'].nil?
      params['settings']['divisions_attributes'].each_pair do |i, divs|
        unless divs['available_times_attributes'].nil?
          divs['available_times_attributes'].each_pair do |j, times|
            unless times['end(4i)'].blank? || times['end(5i)'].blank?
              times['end(1i)'] = times['begin(1i)'].blank? ? '2011' : times['begin(1i)']
              times['end(2i)'] = times['begin(2i)'].blank? ? '1' : times['begin(2i)']
              times['end(3i)'] = times['begin(3i)'].blank? ? '1' : times['begin(3i)']
            end
          end
        end
      end
    end

    if @settings.update_attributes(params[:settings])
      redirect_to(edit_settings_url, :notice => t(:success, :scope => [:settings, :update]))
    else
      @settings.divisions.each {|d| d.available_times.build}
      render :action => 'edit'
    end
  end
end
