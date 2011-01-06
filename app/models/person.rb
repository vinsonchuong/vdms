=begin
Person is an "abstract class" whose purpose is to capture the commonality
between Staff, PeerAdvisor, Faculty, and Admit.  
=end
class Person < ActiveRecord::Base
  ATTRIBUTES = {
    'CalNet ID' => :calnet_id,
    'First Name' => :first_name,
    'Last Name' => :last_name,
    'Email' => :email
  }

  def self.import_csv(csv_text)
    FasterCSV.parse(csv_text, :headers => :first_row) do |row|
      attributes = row.to_hash.rekey do |column|
        self::ATTRIBUTES[column]
      end.reject do |accessor, value|
        accessor.nil?
      end
      self.create(attributes)
    end
  end

  ## abstract factory
  def self.make_person(klass, args={})
    klass.constantize.send(:new, args)
  end
end
