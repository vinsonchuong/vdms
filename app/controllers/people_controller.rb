class PeopleController < ApplicationController
  # GET /people
  def index
    @people = Person.all
  end

  # GET /people/delete_all
  def delete_all
  end

  # GET /people/new
  def new
    @person = Person.new
  end

  # GET /people/upload
  def upload
  end

  # GET /people/1/edit
  def edit
    @person = Person.find(params[:id])
  end

  # GET /people/1/delete
  def delete
    @person = Person.find(params[:id])
  end

  # POST /people
  def create
    @person = Person.new(params[:person])
    if @person.save
      redirect_to(:people, :notice => t('people.create.success'))
    else
      render :action => 'new'
    end
  end

  # POST /people/import
  def import
    @people = Person.new_from_csv(params[:csv_file])
    if @people.all?(&:valid?)
      @people.each {|p| p.save(false)}
      redirect_to(:people, :notice => t('people.import.success'))
    else
      render :action => 'upload'
    end
  end

  # PUT /people/1
  def update
    @person = Person.find(params[:id])
    if @person.update_attributes(params[:person])
      if @person == @current_user
        redirect_to(root_url, :notice => t('people.update.success_alt'))
      else
        redirect_to(:people, :notice => t('people.update.success'))
      end
    else
      render :action => 'edit'
    end
  end

  # DELETE /people/1
  def destroy
    Person.find(params[:id]).destroy
    redirect_to(:people, :notice => t('people.destroy.success'))
  end

  # DELETE /people/destroy_all
  def destroy_all
    Person.destroy_all
    redirect_to(:people, :notice => t('people.destroy_all.success'))
  end
end
