require 'spec_helper'

describe Ranking do
  describe 'Attributes' do
    before(:each) do
      @ranking = Ranking.new
    end

    it 'has a rank (rank)' do
      @ranking.should respond_to(:rank)
      @ranking.should respond_to(:rank=)
    end
  end
end
