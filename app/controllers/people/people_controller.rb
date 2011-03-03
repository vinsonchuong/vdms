class PeopleController < ApplicationController
  before_filter :get_model

  # GET /people/PEOPLE
  def index
    self.instance_variable_set("@#{@collection}", @model.by_name)
  end

  # GET /people/PEOPLE/delete_all
  def delete_all
  end

  # GET /people/PEOPLE/new
  def new
    self.instance_variable_set("@#{@instance}", @model.new)
  end

  # GET /people/PEOPLE/upload
  def upload
  end

  # GET /people/PEOPLE/1/edit
  def edit
    self.instance_variable_set("@#{@instance}", @model.find(params[:id]))
    @origin_action = 'edit'
    @redirect_action = 'index'
  end

  # GET /people/PEOPLE/1/delete
  def delete
    self.instance_variable_set("@#{@instance}", @model.find(params[:id]))
  end

  # POST /people/PEOPLE
  def create
    self.instance_variable_set("@#{@instance}", @model.new(params[@model.name.underscore.to_sym]))
    instance_variable_get("@#{@instance}").ldap_id = @current_user.ldap_id if @current_user.new_record?

    if instance_variable_get("@#{@instance}").save
      if @current_user.new_record?
        redirect_to(self.send("#{@model.name.underscore}_dashboard_url".to_sym), :notice => t(:success, :scope => [:people, @model.name.tableize, :create]))
      else
        redirect_to(self.send("#{@collection}_url".to_sym), :notice => t(:success, :scope => [:people, @model.name.tableize, :create]))
      end
    else
      render :action => 'new'
    end
  end

  # POST /people/PEOPLE/import
  def import
    self.instance_variable_set("@#{@collection}", @model.new_from_csv(params[:csv_file]))

    if instance_variable_get("@#{@collection}").map(&:valid?).all?
      instance_variable_get("@#{@collection}").each(&:save)
      redirect_to(self.send("#{@collection}_url".to_sym), :notice => t(:success, :scope => [:people, @model.name.tableize, :import]))
    else
      render :action => 'upload'
    end
  end

  # PUT /people/PEOPLE/1
  def update
    self.instance_variable_set("@#{@instance}", @model.find(params[:id]))
    attributes = params[@model.name.underscore.to_sym]
    if instance_variable_get("@#{@instance}") == @current_user
      attributes.delete('ldap_id')
    end

    if instance_variable_get("@#{@instance}").update_attributes(attributes)
      flash[:notice] = t(:success, :scope => [:people, @model.name.tableize, :update])
      redirect_to(:action => params[:redirect_action], :record => instance_variable_get("@#{@instance}"))
    else
      @origin_action = params[:origin_action]
      @redirect_action = params[:redirect_action]
      render :action => @origin_action
    end
  end

  # DELETE /people/PEOPLE/1
  def destroy
    self.instance_variable_set("@#{@instance}", @model.find(params[:id])).destroy
    redirect_to(self.send("#{@collection}_url".to_sym), :notice => t(:success, :scope => [:people, @model.name.tableize, :destroy]))
  end

  # DELETE /people/PEOPLE/destroy_all
  def destroy_all
    @model.destroy_all
    redirect_to(self.send("#{@collection}_url".to_sym), :notice => t(:success, :scope => [:people, @model.name.tableize, :destroy_all]))
  end
end
