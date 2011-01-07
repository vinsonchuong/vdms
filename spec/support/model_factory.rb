module ModelFactory
  def valid_attributes_for(model)
    case model.to_s
    when 'Admit'
      return {
        :calnet_id => "00000000",
        :first_name => "AdmitFirstName",
        :last_name => "AdmitLastName",
        :email => "#{random_string(10)}@email.com",
        :phone => "123-456-7890",
        :area1 =>  "EE",
        :area2 => "CS",
        :attending => true,
        :available_times => RangeSet.new([4.hours.ago..3.hours.ago, 1.hour.ago..20.minutes.ago])
      }
    when 'AdmitRanking'
      return {
        :rank => 1,
        :mandatory => true,
        :time_slots => 1,
        :one_on_one => true
      }
    when 'Faculty'
      return {
        :calnet_id => "11111111",
        :first_name => "FacultyFirstName",
        :last_name => "FacultyLastName",
        :email => "#{random_string(10)}@berkeley.edu",
        :area => "Database",
        
        :division => "CS",
        :schedule => Array.new,
        :default_room => "300 Soda",
        :max_students_per_meeting => 3,
        :max_additional_students => 10,
      }
    when 'FacultyRanking'
      return {
        :rank => 1
      }
    when 'Meeting'
      return {
        :time => 1,
        :room => "300 Soda",
        :faculty => create_valid!(Faculty),
        :students => create_valid!(Admit),
      }
    when 'PeerAdvisor'
      return {
        :calnet_id => "11110000",
        :first_name => "PeerAdvisorFirstName",
        :last_name => "PeerAdvisorLastName",
        :email => "#{random_string(10)}@berkeley.edu"
      }
    when 'RangeSet'
      return {

      }
    when 'Staff'
      return {
        :calnet_id => "00001111",
        :first_name => "StaffFirstName",
        :last_name => "StaffLastName",
        :email => "#{random_string(10)}@berkeley.edu"
      }
    else
      raise "Unrecognized Model: #{model.to_s}"
    end
  end

  def build_valid(model, params = {})
    model.new(valid_attributes_for(model).merge(params))    
  end

  def create_valid(model, params = {})
    model.create(valid_attributes_for(model).merge(params))    
  end

  def create_valid!(model, params = {})
    model.create!(valid_attributes_for(model).merge(params))    
  end

  def random_string(length)
    chars = [('A'..'Z'), ('a'..'z'), ('0'..'9')].inject([]) {|arr, ran| arr + ran.to_a}
    (0...length).inject('') {|str, i| str + chars[Kernel.rand(chars.size)]}
  end
end
