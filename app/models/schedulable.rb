module Schedulable
  def self.included(base)
    base.validate do |record| # non-overlapping Available Meeting Times
      record.time_slots.reject(&:marked_for_destruction?).combination(2) do |times|
        if [times[0].begin, times[0].end, times[1].begin, times[1].end].all? && times[0].overlap?(times[1])
          record.errors.add_to_base('Available times must not overlap')
          break
        end
      end
    end
  end

  def build_time_slots(times, length, gap)
    times = RangeSet.new(times.map {|t| (t.begin)..(t.end)}) -
            RangeSet.new(self.time_slots.map {|t| (t.begin)..(t.end + gap)})
    times.each_range do |range|
      range.step(length + gap) do |start|
        if start + length <= range.end
          self.time_slots.build(:begin => start, :end => start + length)
        end
      end
    end
    self.time_slots.sort! {|x, y| x.begin <=> y.begin}
  end
end
