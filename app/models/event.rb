class Event < ActiveRecord::Base
  has_many :time_slots, :autosave => true, :dependent => :destroy
  has_many :host_field_types, :dependent => :destroy
  has_many :visitor_field_types, :dependent => :destroy
  has_many :constraints, :dependent => :destroy
  has_many :goals, :dependent => :destroy
  has_many :roles
  has_many :hosts, :after_add => :build_host_fields, :dependent => :destroy
  has_many :visitors, :after_add => :build_visitor_fields, :dependent => :destroy

  validates_presence_of :name
  validates_presence_of :meeting_length
  validates_numericality_of :meeting_length, :only_integer => true, :greater_than => 0, :allow_blank => true
  validates_presence_of :meeting_gap
  validates_numericality_of :meeting_gap, :only_integer => true, :greater_than_or_equal_to => 0, :allow_blank => true
  validates_inclusion_of :disable_facilitators, :in => [true, false]
  validates_inclusion_of :disable_hosts, :in => [true, false]
  #validates_presence_of :max_meetings_per_visitor
  #validates_numericality_of :max_meetings_per_visitor, :only_integer => true, :greater_than_or_equal_to => 0

  default_scope order('name')

  def meeting_times(options = {})
    times = time_slots.map {|t| (t.begin)...(t.end + meeting_gap)}
    times = Range.combine(*times)
    times.map! {|r| (r.begin)..(r.end - meeting_gap)}
    times.each_with_index do |time, i|
      time.define_singleton_method :id, lambda {i}
      time.define_singleton_method :new_record?, lambda {false}
      time.define_singleton_method :persisted?, lambda {true}
      time.define_singleton_method :_destroy, lambda {}
    end
    if options[:include_blank]
      blank_time = ''..''
      blank_time.define_singleton_method :new_record?, lambda {true}
      blank_time.define_singleton_method :persisted?, lambda {false}
      blank_time.define_singleton_method :begin, lambda {nil}
      blank_time.define_singleton_method :end, lambda {nil}
      times << blank_time
    end
    times
  end

  def meeting_times_attributes=(times)
    if times.class == Array
      times.reject! {|t| t[:_destroy].to_b || t[:begin].blank? || t[:end].blank?}
      times.map! {|t| (t[:begin])..(t[:end])}
    else # Hash
      times.reject! {|k, v| v[:_destroy].to_b || v.values.any?(&:blank?)}
      times = times.map do |k, t|
        (Time.zone.local t['begin(1i)'].to_i, t['begin(2i)'], t['begin(3i)'], t['begin(4i)'], t['begin(5i)'])..
            (Time.zone.local t['end(1i)'].to_i, t['end(2i)'], t['end(3i)'], t['end(4i)'], t['end(5i)'])
      end
    end

    times = Range.combine(*times)
    times.map! do |time|
      start_time = time.begin
      end_time = time.end
      partition = []
      while end_time - start_time >= meeting_length
        partition << (start_time..(start_time + meeting_length))
        start_time += meeting_length + meeting_gap
      end
      partition
    end.flatten!
    current_times = time_slots.map {|t| (t.begin)..(t.end)}
    (times - current_times).each {|t| time_slots.build(:begin => t.begin, :end => t.end)}
    times_to_remove = current_times - times
    time_slots.each {|t| t.mark_for_destruction if times_to_remove.include?((t.begin)..(t.end))}
  end


  def build_host_fields(host)
    host_field_types.each {|t| host.fields.build(:field_type => t)}
  end

  def build_visitor_fields(visitor)
    visitor_field_types.each {|t| visitor.fields.build(:field_type => t)}
  end
end
