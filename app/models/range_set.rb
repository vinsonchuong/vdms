=begin
RangeSets represent a collection of sorted disjoint ranges (a closed set in mathematics). 
All given ranges are treated as including both of their end points.
=end
class RangeSet
  attr_reader :ranges

  def initialize(ranges = nil)
    if ranges.nil? || ranges.empty?
      @ranges = Array.new
    else
      @ranges = Range.combine(*ranges)
    end
  end

  def +(other)
    return RangeSet.new(@ranges + other.ranges)
  end

  def -(other)
    result = []
    other.ranges.each do |s|
      @ranges.each do |r|
        if r.overlap?(s) && r.begin != s.end && r.end != s.begin
          if r.begin >= s.begin and r.end <= s.end
            # do nothing
          elsif r.begin <= s.begin and r.end <= s.end
            result << (r.begin)..(s.begin)
          elsif r.begin >= s.begin and r.end >= s.end
            result << (s.end)..(r.end)
          else # r.begin <= s.begin and r.end >= s.end
            result << (r.begin)..(s.begin)
            result << (s.end)..(r.end)
          end
        else
          result << r
        end
      end
    end
    return RangeSet.new(result)
  end

  def inspect
    return sprintf('#<%s: %s>', self.class, @ranges.inspect)
  end
end