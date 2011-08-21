module Importable
  module ClassMethods
    def new_from_csv(csv_text)
      result = []
      FasterCSV.parse(csv_text, :headers => :first_row) do |row|
        result << self.new(self.convert_attributes(row))
      end
      result
    end
  
    def convert_attributes(csv_row)
      attributes = csv_row.to_hash
      rankings = []
      attributes.delete_if do |col, value|
        if col =~ /^Faculty (\d+)$/
          ranking_attributes = {:rank => $1.to_i}
          if value =~ /(\w+)\s+(\w+)/
            faculty = Faculty.find_by_first_name_and_last_name($1, $2)
            ranking_attributes[:rankable] = faculty
          end
          rankings << ranking_attributes
          true
        else
          false
        end
      end
      attributes.update_keys {|col| self::ATTRIBUTES[col]}
      attributes.delete_if {|accessor, value| accessor.nil?}
      attributes.update_each do |accessor, value|
        conversion = case self::ATTRIBUTE_TYPES[accessor]
        when :integer then :to_i
        when :boolean then :to_b
        else :to_s
        end
        {accessor => value.send(conversion)}
      end
      unless rankings.empty?
        attributes.merge({:rankings_attributes => rankings})
      else
        attributes
      end
    end
  end

  def self.included(base)
    base.extend ClassMethods
  end
end
