Factory.define :person do |p|
  p.name 'First Last'
  p.role 'user'
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

Factory.define :time_slot do |t|
  t.begin {Time.zone.parse('1/1/2011')}
  t.end {Time.zone.parse('1/2/2011')}
  t.settings {Settings.instance}
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

Factory.define :host do |h|
  h.association :person
  h.event {Settings.instance}
end

Factory.define :visitor do |v|
  v.association :person
  v.event {Settings.instance}
end
