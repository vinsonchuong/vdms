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

  validates_presence_of :calnet_id, :unless => Proc.new {|person| person.class == Admit}
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :email
  validates_format_of :email, :with => /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i

  def self.import_csv(csv_text)
    result = []
    FasterCSV.parse(csv_text, :headers => :first_row) do |row|
      attributes = row.to_hash.rekey do |column|
        self::ATTRIBUTES[column]
      end.reject do |accessor, value|
        accessor.nil?
      end
      result << self.create(attributes)
    end
    result
  end

  ## abstract factory
  def self.make_person(klass, args={})
    klass.constantize.send(:new, args)
  end
end
