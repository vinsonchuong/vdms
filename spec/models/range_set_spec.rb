require 'spec_helper'

describe RangeSet do
  context 'when inspecting' do
    it 'returns #<RangeSet: []> when empty' do
      RangeSet.new.inspect.should == '#<RangeSet: []>'
    end

    it 'returns #<RangeSet: [1..2]> when representing [1, 2]' do
      RangeSet.new([1..2]).inspect.should == '#<RangeSet: [1..2]>'
    end

    it 'returns #<RangeSet: [1..2, 3..4] when representing [1, 2] U [3, 4]' do
      RangeSet.new([1..2, 3..4]).inspect.should == '#<RangeSet: [1..2, 3..4]>'
    end
  end

  context 'when converting' do
    context 'to an array' do
      it 'returns [] when empty' do
        RangeSet.new.to_a.should == []
      end

      it 'returns [1..2] when representing [1, 2]' do
        RangeSet.new([1..2]).to_a.should == [1..2]
      end

      it 'returns [1..2, 3..4] when representing [1, 2] U [3, 4]' do
        RangeSet.new([1..2, 3..4]).to_a.should == [1..2, 3..4]
      end
    end
  end
  
  context 'when creating' do
    it 'returns an empty RangeSet given no argument' do
      RangeSet.new.to_a.should == []
    end

    it 'returns an empty RangeSet given an empty enumerable' do
      RangeSet.new([]).to_a.should == []
    end

    it 'returns a RangeSet representing [1, 2] when given [1..2]' do
      RangeSet.new([1..2]).to_a.should == [1..2]
    end

    it 'returns a RangeSet representing [1, 2] U [3, 4] when given [1..2, 3..4]' do
      RangeSet.new([1..2, 3..4]).to_a.should == [1..2, 3..4]
    end

    it 'returns a RangeSet representing [1, 3] when given [1..2, 2..3]' do
      RangeSet.new([1..2, 2..3]).to_a.should == [1..3]
    end

    it 'returns a RangeSet representing [1, 3] U [4, 6] when given [1..2, 4..5, 2..3, 4..6]' do
      RangeSet.new([1..2, 4..5, 2..3, 4..6]).to_a.should == [1..3, 4..6]
    end
  end

  context 'when unioning with another RangeSet' do
    it 'returns RangeSet [1, 2] U [3, 4] when given RangeSets [1, 2] + [3, 4]' do
      (RangeSet.new([1..2]) + RangeSet.new([3..4])).to_a.should == [1..2, 3..4]
    end

    it 'returns RangeSet [1, 3] when given RangeSets [1, 2] + [2, 3]' do
      (RangeSet.new([1..2]) + RangeSet.new([2..3])).to_a.should == [1..3]
    end

    it 'returns RangeSet [1, 3] U [4, 5] when given RangeSets [1, 2] + [2, 3] U [4, 5]' do
      (RangeSet.new([1..2]) + RangeSet.new([2..3, 4..5])).to_a.should == [1..3, 4..5]
    end

    it 'returns an empty RangeSet given two empty RangeSets' do
      (RangeSet.new + RangeSet.new).to_a.should == []
    end

    it 'returns RangeSet [1, 2] when given RangeSets empty + [1, 2]' do
      (RangeSet.new + RangeSet.new([1..2])).to_a.should == [1..2]
      (RangeSet.new([1..2]) + RangeSet.new).to_a.should == [1..2]
    end
  end

  context 'when subtracting another RangeSet' do
    it 'returns an empty RangeSet given two empty RangeSets' do
      (RangeSet.new - RangeSet.new).to_a.should == []
    end

    it 'returns RangeSet [1, 2] given RangeSets [1, 2] - empty' do
      (RangeSet.new([1..2]) - RangeSet.new).to_a.should == [1..2]
    end

    it 'returns RangeSet [4, 5] given RangeSets [4, 5] - [1, 3]' do
      (RangeSet.new([4..5]) - RangeSet.new([1..3])).to_a.should == [4..5]
    end

    it 'returns RangeSet [4, 5] given RangeSets [4, 5] - [1, 4]' do
      (RangeSet.new([4..5]) - RangeSet.new([1..4])).to_a.should == [4..5]
    end

    it 'returns RangeSet [4, 5] given RangeSets [4, 5] - [1, 3]' do
      (RangeSet.new([4..5]) - RangeSet.new([1..3])).to_a.should == [4..5]
    end

    it 'returns RangeSet [4, 5] given RangeSets [4, 5] - [5, 7]' do
      (RangeSet.new([4..5]) - RangeSet.new([5..7])).to_a.should == [4..5]
    end

    it 'returns an empty RangeSet given RangeSets [4, 5] - [4, 5]' do
      (RangeSet.new([4..5]) - RangeSet.new([4..5])).to_a.should == []
    end

    it 'returns an empty RangeSet given RangeSets [4, 5] - [3, 5]' do
      (RangeSet.new([4..5]) - RangeSet.new([3..5])).to_a.should == []
    end

    it 'returns an empty RangeSet given RangeSets [4, 5] - [4, 6]' do
      (RangeSet.new([4..5]) - RangeSet.new([4..6])).to_a.should == []
    end

    it 'returns an empty RangeSet given RangeSets [4, 5] - [3, 7]' do
      (RangeSet.new([4..5]) - RangeSet.new([3..7])).to_a.should == []
    end

    it 'returns RangeSet [3, 4] given RangeSets [3, 5] - [4, 5]' do
      (RangeSet.new([3..5]) - RangeSet.new([4..5])).to_a.should == [3..4]
    end

    it 'returns RangeSet [3, 4] given RangeSets [3, 5] - [4, 6]' do
      (RangeSet.new([3..5]) - RangeSet.new([4..6])).to_a.should == [3..4]
    end

    it 'returns RangeSet [3, 4] given RangeSets [1, 4] - [1, 3]' do
      (RangeSet.new([1..4]) - RangeSet.new([1..3])).to_a.should == [3..4]
    end

    it 'returns RangeSet [3, 4] given RangeSets [1, 4] - [0, 3]' do
      (RangeSet.new([1..4]) - RangeSet.new([0..3])).to_a.should == [3..4]
    end

    it 'returns RangeSet [3, 4] U [5, 6] given RangeSets [3, 6] - [4, 5]' do
      (RangeSet.new([3..6]) - RangeSet.new([4..5])).to_a.should == [3..4, 5..6]
    end

    it 'returns RangeSet [3, 4] U [5, 6] given RangeSets [1, 4] U [5, 6] - [0, 3]' do
      (RangeSet.new([1..4]) - RangeSet.new([0..3])).to_a.should == [3..4]
    end

    it 'returns RangeSet [1, 3] U [7, 9] given RangeSets [1, 4] U [6, 9] - [3, 7]' do
      (RangeSet.new([1..4, 6..9]) - RangeSet.new([3..7])).to_a.should == [1..3, 7..9]
    end

    it 'returns RangeSet [1, 2] U [3, 4] U [6, 7] U [8, 9] given RangeSets [1, 4] U [6, 9] - [2, 3] U [7, 8]' do
      (RangeSet.new([1..4, 6..9]) - RangeSet.new([2..3, 7..8])).to_a.should == [1..2, 3..4, 6..7, 8..9]
    end

    it 'returns RangeSet [320, 340] given RangeSets [300, 360] - [300, 320] U [340, 360]' do
      (RangeSet.new([300..360]) - RangeSet.new([300..320, 340..360])).to_a.should == [320..340]
    end
  end

  context 'when determining containment' do
    context 'of a given element (#contain_element?)' do
      it 'returns true given 1 E [1, 3]' do
        RangeSet.new([1..3]).contain_element?(1).should be_true
      end

      it 'returns true given 2 E [1, 3]' do
        RangeSet.new([1..3]).contain_element?(2).should be_true
      end

      it 'returns true given 3 E [1, 3]' do
        RangeSet.new([1..3]).contain_element?(3).should be_true
      end

      it 'returns false given 0 E [1, 3]' do
        RangeSet.new([1..3]).contain_element?(0).should be_false
      end

      it 'returns false given 4 E [1, 3]' do
        RangeSet.new([1..3]).contain_element?(4).should be_false
      end

      it 'returns true given 2 E [1, 3] U [5, 7]' do
        RangeSet.new([1..3, 5..7]).contain_element?(2).should be_true
      end

      it 'returns true given 6 E [1, 3] U [5, 7]' do
        RangeSet.new([1..3, 5..7]).contain_element?(6).should be_true
      end

      it 'returns false given 4 E [1, 3] U [5, 7]' do
        RangeSet.new([1..3, 5..7]).contain_element?(4).should be_false
      end
    end

    context 'of a  given set (#contains_set?)' do
      it 'returns true given empty C [3, 4]' do
        RangeSet.new([3..4]).contain_set?(RangeSet.new).should be_true
      end

      it 'returns true given [3, 4] C [2, 5]' do
        RangeSet.new([2..5]).contain_set?(RangeSet.new([3..4])).should be_true
      end

      it 'returns true given [3, 4] C [3, 5]' do
        RangeSet.new([3..5]).contain_set?(RangeSet.new([3..4])).should be_true
      end

      it 'returns true given [3, 4] C [2, 4]' do
        RangeSet.new([2..4]).contain_set?(RangeSet.new([3..4])).should be_true
      end

      it 'returns true given [3, 4] C [3, 4]' do
        RangeSet.new([3..4]).contain_set?(RangeSet.new([3..4])).should be_true
      end

      it 'returns false given [3, 6] C [4, 5]' do
        RangeSet.new([4..5]).contain_set?(RangeSet.new([3..6])).should be_false
      end

      it 'returns false given [4, 6] C [4, 5]' do
        RangeSet.new([4..5]).contain_set?(RangeSet.new([4..6])).should be_false
      end

      it 'returns false given [3, 5] C [4, 5]' do
        RangeSet.new([4..5]).contain_set?(RangeSet.new([3..5])).should be_false
      end

      it 'returns true given [3, 4] C [3, 4] U [5, 6]' do
        RangeSet.new([3..4, 5..6]).contain_set?(RangeSet.new([3..4])).should be_true
      end

      it 'returns false given [3, 6] C [3, 4] U [5, 6]' do
        RangeSet.new([3..4, 5..6]).contain_set?(RangeSet.new([3..6])).should be_false
      end
    end
  end

  context 'when iterating' do
    context 'over ranges' do
      it 'yields every each range once' do
        [
          RangeSet.new,
          RangeSet.new([1..2]),
          RangeSet.new([1..2, 2..3]),
          RangeSet.new([1..2, 3..4, 5..6])
        ].each do |set|
          result = []
          set.each_range {|r| result << r}
          result.should == set.to_a
        end
      end
    end
  end
end
