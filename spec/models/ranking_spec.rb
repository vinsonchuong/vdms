require 'spec_helper'

describe Ranking do
  describe 'Attributes' do
    before(:each) do
      @ranking = Ranking.new
    end

    it 'has a Rank (rank)' do
      @ranking.should respond_to(:rank)
      @ranking.should respond_to(:rank=)
    end
  end

  it 'has an attribute name to accessor map' do
    Ranking::ATTRIBUTES['Rank'].should == :rank
  end
end
