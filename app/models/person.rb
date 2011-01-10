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
  ATTRIBUTE_TYPES = {
    :calnet_id => :string,
    :first_name => :string,
    :last_name => :string,
    :email => :string
  }

  validates_presence_of :calnet_id, :unless => Proc.new {|person| person.class == Admit}
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :email
  validates_format_of :email, :with => /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i

  def self.import_csv(csv_text)
    result = []
    transaction do
      FasterCSV.parse(csv_text, :headers => :first_row) do |row|
        attributes = row.to_hash
        attributes.update_keys {|column| self::ATTRIBUTES[column]}
        attributes.delete_if {|accessor, value| accessor.nil?}
        attributes.update_each do |accessor, value|
          conversion = case self::ATTRIBUTE_TYPES[accessor]
          when :integer then :to_i
          when :boolean then :to_b
          else :to_s
          end
          {accessor, value.send(conversion)}
        end
        new_person = self.new(attributes)
        result << new_person
        new_person.save
      end
      raise ActiveRecord::Rollback unless result.all? {|r| r.valid?} 
    end
    result
  end

  ## abstract factory
  def self.make_person(klass, args={})
    klass.constantize.send(:new, args)
  end
end
