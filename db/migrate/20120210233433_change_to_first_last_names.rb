class ChangeToFirstLastNames < ActiveRecord::Migration
  class Person < ActiveRecord::Base
  end

  def up
    add_column :people, :first_name, :string
    add_column :people, :last_name, :string
    Person.reset_column_information
    Person.all.each do |person|
      first, last = person.name.split(' ')
      person.update_attributes!(first_name: first, last_name: last)
    end
    remove_column :people, :name
  end

  def down
    add_column :people, :name, :string
    Person.reset_column_information
    Person.all.each do |person|
      person.update_attributes!(name: person.first_name + person.last_name)
    end
    remove_column :people, :first_name
    remove_column :people, :last_name
  end
end
