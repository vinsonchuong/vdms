Factory.sequence(:email) {|n| "email#{n}@email.com"}

Factory.define :staff do |s|
  s.calnet_id 'CalNet.ID'
  s.first_name 'First'
  s.last_name 'Last'
  s.email {Factory.next(:email)}
end

Factory.define :peer_advisor do |p|
  p.calnet_id 'CalNet.ID'
  p.first_name 'First'
  p.last_name 'Last'
  p.email {Factory.next(:email)}
end

Factory.define :faculty do |f|
  f.calnet_id 'CalNet.ID'
  f.first_name 'First'
  f.last_name 'Last'
  f.email {Factory.next(:email)}
  f.area 'Area'
  f.division Settings.instance.divisions.first.name
end

Factory.define :admit do |a|
  a.calnet_id 'CalNet.ID'
  a.first_name 'First'
  a.last_name 'Last'
  a.email {Factory.next(:email)}
  a.phone '1234567890'
  a.area1 'Area 1'
  a.area2 'Area 2'
end

Factory.define :available_time do |t|
  t.begin {Time.parse('1/1/2011')}
  t.end {Time.parse('1/2/2011')}
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
  m.time {Time.now + 50000}
  m.room 'Room'
  m.association :faculty
end
