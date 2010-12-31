require 'spec_helper'

describe RangeSet do
  describe 'standard methods' do
    describe '#inspect' do
      it 'returns #<RangeSet: []> when empty' do
        RangeSet.new.inspect.should == '#<RangeSet: []>'
      end
    end
  end
  
  context 'when creating' do
    context 'given no arguments' do
      it 'returns an empty RangeSet' do
        pending
        RangeSet.new.to_a.should == []
      end
    end
  end
end
