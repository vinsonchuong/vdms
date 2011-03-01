=begin
A RangeSet represents a collection of sorted disjoint ranges (a closed set in mathematics). 
All given ranges are treated as including both of their end points.

Terminology:
  A set refers to a RangeSet (a closed set)
  A range refers to an element of @ranges (a maximal closed interval contained in the RangeSet)
  An element refers to an element of a contained range (a point in the set)

Note that a RangeSet containing a single range is not equivalent to that range.
Unless otherwise stated (in the method name for instance), methods take other RangeSets.
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
    if @ranges.empty? && other.ranges.empty?
      return RangeSet.new
    else
      return RangeSet.new(@ranges + other.ranges)
    end
  end

  def -(other)
    result = @ranges.dup
    working = result.dup
    other.ranges.each do |s|
      working.each do |r|
        if r.overlap?(s) && r.begin != s.end && r.end != s.begin
          result.delete(r)
          if r.begin >= s.begin and r.end <= s.end
            # do nothing
          elsif r.begin <= s.begin and r.end <= s.end
            result << ((r.begin)..(s.begin))
          elsif r.begin >= s.begin and r.end >= s.end
            result << ((s.end)..(r.end))
          else # r.begin <= s.begin and r.end >= s.end
            result << ((r.begin)..(s.begin))
            result << ((s.end)..(r.end))
          end
        end
      end
      working = result.dup
    end
    return RangeSet.new(result)
  end

  def contain_element?(element)
    @ranges.any? {|r| r.include?(element)}
  end

  def contain_set?(other)
    other.ranges.all? {|r| contain_element?(r)}
  end

  def each_range
    @ranges.each {|r| yield r}
  end

  def inspect
    return sprintf('#<%s: %s>', self.class, @ranges.inspect)
  end

  def to_a
    return @ranges.dup
  end
end