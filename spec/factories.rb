Factory.define :person do |p|
  p.name 'First Last'
  p.email 'email@email.com'
  p.role 'user'
end

Factory.define :event do |e|
  e.name 'Event'
  e.meeting_length 15
  e.meeting_gap 0
  e.max_meetings_per_visitor 25
end

Factory.define :time_slot do |t|
  t.begin {Time.zone.parse('1/1/2011')}
  t.end {Time.zone.parse('1/2/2011')}
  t.association :event
end

Factory.define :host_field_type do |f|
  f.sequence(:name) {|n| "Field#{n}"}
  f.description 'Description'
  f.data_type 'text'
  f.association :event
end

Factory.define :visitor_field_type do |f|
  f.sequence(:name) {|n| "Field#{n}"}
  f.description 'Description'
  f.data_type 'text'
  f.association :event
end

Factory.define :host do |h|
  h.association :person
  h.association :event
  h.verified true
end

Factory.define :visitor do |v|
  v.association :person
  v.association :event
  v.verified true
end

Factory.define :host_field do |f|
  f.data 'Data'
  f.association :role, :factory => :host
  f.association :field_type, :factory => :host_field_type
end

Factory.define :visitor_field do |f|
  f.data 'Data'
  f.association :role, :factory => :visitor
  f.association :field_type, :factory => :visitor_field_type
end

Factory.define :host_ranking do |r|
  r.sequence(:rank) {|n| n}
  r.association :ranker, :factory => :host
  r.association :rankable, :factory => :visitor
end

Factory.define :visitor_ranking do |r|
  r.sequence(:rank) {|n| n}
  r.association :ranker, :factory => :visitor
  r.association :rankable, :factory => :host
end

Factory.define :host_availability do |a|
  a.room 'Room'
  a.available true
  a.association :time_slot
  a.association :host
end

Factory.define :visitor_availability do |a|
  a.available true
  a.association :time_slot
  a.association :visitor
end
