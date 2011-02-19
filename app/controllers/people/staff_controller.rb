class StaffController < PeopleController
  private

  def get_model
    @model = Staff
    @collection = 'staff'
    @instance = 'staff_instance'
  end
end
