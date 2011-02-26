require 'spec_helper'
require 'cancan/matchers'

describe PersonAbility do
  describe Staff do
    it "should be able to manage every model" do
      PersonAbility.new(Factory.create(:staff)).should be_able_to(:manage, :all)
    end
  end
  
  describe Faculty do
    before(:each) do
      @current_user = Factory.create(:faculty)
      @another_user = Factory.create(:faculty)
      @ability = PersonAbility.new(@current_user)
    end
    
    it "should only be able to read and update his/her own Faculty model" do
      [:read, :update].each { |action| @ability.should be_able_to(action, @current_user) }
      [:create, :destroy].each { |action| @ability.should_not be_able_to(action, @current_user) }
      @ability.should_not be_able_to(:manage, @another_user)
      
    end
    
    it "should only be able to CRUD his/her own AdmitRankings" do
      @ability.should be_able_to(:manage, Factory.create(:admit_ranking, :faculty_id => @current_user.id))
      @ability.should_not be_able_to(:manage, Factory.create(:admit_ranking, :faculty_id => @another_user.id))
    end
  
    it "should only be able to CRUD his/her own AvailableTimes" do
      pending
      @ability.should be_able_to(:manage, Factory.create(:available_time, :schedulable_id => @current_user.id))
#      @ability.should_not be_able_to(:manage, Factory.create(:available_time, :schedulable_id => @another_user.id))
    end
  end
  
  describe PeerAdvisor do
    before(:each) do
      @current_user = Factory.create(:peer_advisor)
      @ability = PersonAbility.new(@current_user)
    end
  end
  
  describe Admit do
    before(:each) do
      @current_user = Factory.create(:admit)
      @ability = PersonAbility.new(@current_user)
    end
    
    it "should have no access to anything" do
      @ability.should_not be_able_to(:manage, :all)
    end    
  end
end
