class PeopleController < ApplicationController
  respond_to :html, :json

  # GET /people
  def index
    @people = Person.all
    respond_with @people
  end

  # GET /people/new
  def new
    @person = Person.new
    respond_with @person
  end

  # GET /people/upload
  def upload
  end

  # GET /people/1/edit
  def edit
    @person = Person.find(params[:id])
    respond_with @person
  end

  # GET /people/1/delete
  def delete
    @person = Person.find(params[:id])
    respond_with @person
  end

  # POST /people
  def create
    @person = Person.new(params[:person])
    flash[:notice] = t('people.create.success') if @person.save
    respond_with @person, :location => :people
  end

  # POST /people/import
  def import
    @people = Person.new_from_csv(params[:csv_file])
    if @people.all?(&:valid?)
      @people.each {|p| p.save(:validate => false)}
      redirect_to(:people, :notice => t('people.import.success'))
    else
      render :action => 'upload'
    end
  end

  # PUT /people/1
  def update
    @person = Person.find(params[:id])
    if @person.update_attributes(params[:person])
      flash[:notice] = @person == @current_user ?
                         t('people.update.success_alt') :
                         t('people.update.success')
    end
    respond_with @person, :location => @person == @current_user ? root_url : {:action => 'index'}
  end

  # DELETE /people/1
  def destroy
    @person = Person.find(params[:id])
    @person.destroy
    flash[:notice] = t('people.destroy.success')
    respond_with(@person)
  end
end
