class SettingsController < ApplicationController
  # GET /settings/edit
  def edit
    @settings = Settings.instance
    @settings.divisions.each {|d| d.available_times.build}
  end

  # PUT /settings
  def update
    @settings = Settings.instance

    if @settings.update_attributes(params[:settings])
      redirect_to(edit_settings_url, :notice => t(:success, :scope => [:settings, :update]))
    else
      render :action => 'edit'
    end
  end
end
