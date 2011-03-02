module Schedulable
  def self.included(base)
    base.has_many :available_times, :as => :schedulable, :order => 'begin ASC', :dependent => :destroy
    base.accepts_nested_attributes_for :available_times, :reject_if => :all_blank, :allow_destroy => true

    base.validate do |record| # non-overlapping Available Meeting Times
      record.available_times.reject(&:marked_for_destruction?).combination(2) do |times|
        if [times[0].begin, times[0].end, times[1].begin, times[1].end].all? && times[0].overlap?(times[1])
          record.errors.add_to_base('Available times must not overlap')
          break
        end
      end
    end
  end

  def build_available_times(times, length, gap)
    times = RangeSet.new(times.map {|t| (t.begin)..(t.end)}) -
            RangeSet.new(self.available_times.map {|t| (t.begin)..(t.end + gap)})
    times.each_range do |range|
      range.step(length + gap) do |start|
        if start + length <= range.end
          self.available_times.build(:begin => start, :end => start + length)
        end
      end
    end
    self.available_times.sort! {|x, y| x.begin <=> y.begin}
  end
end
