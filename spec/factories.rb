Factory.sequence(:ldap_id) {|n| "LDAP.ID#{n}"}
Factory.sequence(:email) {|n| "email#{n}@email.com"}

Factory.define :staff do |s|
  s.ldap_id {Factory.next(:ldap_id)}
  s.first_name 'First'
  s.last_name 'Last'
  s.email {Factory.next(:email)}
end

Factory.define :peer_advisor do |p|
  p.ldap_id {Factory.next(:ldap_id)}
  p.first_name 'First'
  p.last_name 'Last'
  p.email {Factory.next(:email)}
end

Factory.define :faculty do |f|
  f.ldap_id {Factory.next(:ldap_id)}
  f.first_name 'First'
  f.last_name 'Last'
  f.email {Factory.next(:email)}
  f.area Settings.instance.areas.keys.first
  f.division Settings.instance.divisions.first.name
end

Factory.define :admit do |a|
  a.ldap_id {Factory.next(:ldap_id)}
  a.first_name 'First'
  a.last_name 'Last'
  a.email {Factory.next(:email)}
  a.phone '1234567890'
  a.area1 Settings.instance.areas.keys.first
  a.area2 Settings.instance.areas.keys.last
end

Factory.define :available_time do |t|
  t.begin {Time.zone.parse('1/1/2011')}
  t.end {Time.zone.parse('1/2/2011')}
  t.room 'Room'
  t.association :schedulable, :factory => :admit
end

Factory.define :admit_ranking do |r|
  r.sequence(:rank) {|n| n}
  r.association :faculty
  r.association :admit
end

Factory.define :faculty_ranking do |r|
  r.sequence(:rank) {|n| n}
  r.association :admit
  r.association :faculty
end

Factory.define :meeting do |m|
  m.time {Time.zone.now + 50000}
  m.room 'Room'
  m.association :faculty
end
