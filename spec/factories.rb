Factory.sequence(:id) {|n| n}
Factory.sequence(:ldap_id) {|n| "LDAP.ID#{n}"}
Factory.sequence(:email) {|n| "email#{n}@email.com"}

Factory.define :person do |p|
  p.id {Factory.next(:id)}
  p.ldap_id {Factory.next(:ldap_id)}
  p.first_name 'First'
  p.last_name 'Last'
  p.email {Factory.next(:email)}
end

Factory.define :staff do |s|
  s.id {Factory.next(:id)}
  s.ldap_id {Factory.next(:ldap_id)}
  s.first_name 'First'
  s.last_name 'Last'
  s.email {Factory.next(:email)}
end

Factory.define :peer_advisor do |p|
  p.id {Factory.next(:id)}
  p.ldap_id {Factory.next(:ldap_id)}
  p.first_name 'First'
  p.last_name 'Last'
  p.email {Factory.next(:email)}
end

Factory.define :faculty do |f|
  f.id {Factory.next(:id)}
  f.ldap_id {Factory.next(:ldap_id)}
  f.first_name 'First'
  f.last_name 'Last'
  f.email {Factory.next(:email)}
  f.area Settings.instance.areas.keys.first
  f.division Settings.instance.divisions.keys.first
end

Factory.define :admit do |a|
  a.id {Factory.next(:id)}
  a.ldap_id {Factory.next(:ldap_id)}
  a.first_name 'First'
  a.last_name 'Last'
  a.email {Factory.next(:email)}
  a.phone '1234567890'
  a.area1 Settings.instance.areas.keys.first
  a.area2 Settings.instance.areas.keys.last
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
  h.association :person, :factory => :person
  h.event {Settings.instance}
end

Factory.define :visitor do |v|
  v.association :person, :factory => :person
  v.event {Settings.instance}
end
