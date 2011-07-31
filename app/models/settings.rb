class Settings < ActiveRecord::Base
  include Singleton

  def after_initialize
    if self.new_record?
      self.unsatisfied_admit_threshold ||= 0
      self.faculty_weight ||= 1
      self.admit_weight ||= 1
      self.rank_weight ||= 1
      self.mandatory_weight ||= 1
      self.disable_faculty ||= false
      self.disable_peer_advisors ||= false
    end
  end

  has_many :time_slots, :order => 'begin ASC', :dependent => :destroy
  has_many :hosts, :foreign_key => 'event_id'
  has_many :visitors, :foreign_key => 'event_id'
  accepts_nested_attributes_for :time_slots

  validates_presence_of :unsatisfied_admit_threshold
  validates_numericality_of :unsatisfied_admit_threshold, :only_integer => true, :greater_than_or_equal_to => 0
  validates_numericality_of :faculty_weight, :only_integer => true, :greater_than_or_equal_to => 0
  validates_numericality_of :admit_weight, :only_integer => true, :greater_than_or_equal_to => 0
  validates_numericality_of :rank_weight, :only_integer => true, :greater_than_or_equal_to => 0
  validates_numericality_of :mandatory_weight, :only_integer => true, :greater_than_or_equal_to => 0
  validates_inclusion_of :disable_faculty, :in => [true, false]
  validates_inclusion_of :disable_peer_advisors, :in => [true, false]
  validate :time_slot_overlap

  def self.instance
    self.find(:all).first || self.send(:create)
  end

  def meeting_times
    times = time_slots.map {|t| (t.begin)...(t.end + meeting_gap)}
    times = Range.combine(*times)
    times.map! do |r|
      time = (r.begin)..(r.end - meeting_gap)
      def time.new_record?; false end
      def time._destroy; end
      time
    end
  end

  def meeting_times_attributes=(times)
    if times.class == Array
      times.reject! {|t| t[:_destroy].to_b || t[:begin].blank? || t[:end].blank?}
      times.map! {|t| (t[:begin])..(t[:end])}
    else # Hash
      times.reject! {|k, v| v[:_destroy].to_b || v.values.any?(&:blank?)}
      times = times.map do |k, t|
        (Time.zone.local t['begin(1i)'], t['begin(2i)'], t['begin(3i)'], t['begin(4i)'], t['begin(5i)'])..
            (Time.zone.local t['end(1i)'], t['end(2i)'], t['end(3i)'], t['end(4i)'], t['end(5i)'])
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

  def method_missing(method, *args, &block)
    STATIC_SETTINGS[method.to_s] || super
  end

  def time_slot_overlap
    errors.add :time_slot, :overlap if time_slots.reject(&:marked_for_destruction?).combination(2).any? {|x, y| x.overlap?(y)}
  end
end
