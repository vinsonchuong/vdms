FactoryGirl.define do
  factory :person do
    last_name 'Last'
    first_name 'First'
    email 'email@email.com'
    role 'user'
  end

  factory :event do
    name 'Event'
    meeting_length 15
    meeting_gap 0
    max_meetings_per_visitor 25
  end

  factory :host_field_type do
    sequence(:name) {|n| "Host Field #{n}"}
    description 'Description'
    data_type 'text'
    event
  end

  factory :visitor_field_type do
    sequence(:name) {|n| "Visitor Field #{n}"}
    description 'Description'
    data_type 'text'
    event
  end

  factory :constraint do
    sequence(:name) {|n| "Constraint #{n}"}
    weight 1
    feature_type 'equality/equals'
    event
    host_field_type
    visitor_field_type
  end

  factory :goal do
    sequence(:name) {|n| "Goal #{n}"}
    weight 1
    feature_type 'equality/equals'
    event
    host_field_type
    visitor_field_type
  end

  factory :host do
    verified true
    person
    event
  end

  factory :visitor do
    verified true
    person
    event
  end

  factory :host_field do
    data 'Data'
    association :role, :factory => :host
    association :field_type, :factory => :host_field_type
  end

  factory :visitor_field do
    data 'Data'
    association :role, :factory => :visitor
    association :field_type, :factory => :visitor_field_type
  end

  factory :host_ranking do
    sequence(:rank) {|n| n}
    association :ranker, :factory => :host
    association :rankable, :factory => :visitor
  end

  factory :visitor_ranking do
    sequence(:rank) {|n| n}
    association :ranker, :factory => :visitor
    association :rankable, :factory => :host
  end

  factory :host_availability do
    room 'Room'
    available true
    time_slot
    association :schedulable, :factory => :host
  end

  factory :visitor_availability do
    available true
    time_slot
    association :schedulable, :factory => :visitor
  end

  factory :meeting do
    host_availability
    visitor_availability
    after_build do |meeting|
      meeting.host_availability.available = true
      meeting.visitor_availability.available = true
    end
  end
end

Factory.define :time_slot do |t|
  t.begin {Time.zone.parse('1/1/2011')}
  t.end {Time.zone.parse('1/2/2011')}
  t.association :event
end
