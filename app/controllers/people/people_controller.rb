class PeopleController < ApplicationController
  before_filter :set_model

  # GET /people/PEOPLE
  def index
    self.instance_variable_set("@#{@model.name.tableize}", @model.all)
  end

  # GET /people/PEOPLE/new
  def new
    self.instance_variable_set("@#{@model.name.underscore}", @model.new)      
  end

  # GET /people/PEOPLE/upload
  def upload
  end

  # GET /people/PEOPLE/1/edit
  def edit
    self.instance_variable_set("@#{@model.name.underscore}", @model.find(params[:id]))
  end

  # GET /people/PEOPLE/1/delete
  def delete
    self.instance_variable_set("@#{@model.name.underscore}", @model.find(params[:id]))
  end

  # POST /people/PEOPLE
  def create
    self.instance_variable_set("@#{@model.name.underscore}", @model.new(params[@model.name.underscore.to_sym]))

    if instance_variable_get("@#{@model.name.underscore}").save
      redirect_to(self.send("#{@model.name.tableize}_url".to_sym), :notice => "#{@model.name.titleize} was successfully added.")
    else
      render :action => 'new'
    end
  end

  # POST /people/PEOPLE/import
  def import
    self.instance_variable_set("@#{@model.name.tableize}", @model.new_from_csv(params[:csv_file]))

    if instance_variable_get("@#{@model.name.tableize}").map(&:valid?).all?
      instance_variable_get("@#{@model.name.tableize}").each(&:save)
      redirect_to(self.send("#{@model.name.tableize}_url".to_sym), :notice => "#{@model.name.titleize.pluralize} were successfully imported.")
    else
      render :action => 'upload'
    end
  end

  # PUT /people/PEOPLE/1
  def update
    self.instance_variable_set("@#{@model.name.underscore}", @model.find(params[:id]))

    if instance_variable_get("@#{@model.name.underscore}").update_attributes(params[@model.name.underscore.to_sym])
      redirect_to(self.send("#{@model.name.tableize}_url".to_sym), :notice => "#{@model.name.titleize} was successfully updated.")
    else
      render :action => 'edit'
    end
  end

  # DELETE /people/PEOPLE/1
  def destroy
    self.instance_variable_set("@#{@model.name.underscore}", @model.find(params[:id])).destroy
    redirect_to(self.send("#{@model.name.tableize}_url".to_sym), :notice => "#{@model.name.titleize} was removed.")
  end
end
