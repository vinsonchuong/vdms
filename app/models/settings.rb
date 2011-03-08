class Settings < ActiveRecord::Base
  include Singleton

  def after_initialize
    if self.new_record?
      self.unsatisfied_admit_threshold ||= 0
      self.disable_faculty ||= false
      self.disable_peer_advisors ||= false
    end
  end
  after_save do |record|
    if record.divisions.empty?
      STATIC_SETTINGS['divisions'].each_key {|name| record.divisions.create(:name => name)}
    end

    if record.scheduler_factors_table.nil?
      values = {}
      keys = STATIC_SETTINGS['scheduler_scores'].each_key.collect{ |key| key.to_sym }
      STATIC_SETTINGS['scheduler_scores'].each_value.collect{ |val| val.to_f }.zip(keys) do |val, key|
        values[key] = val
      end
      keys = STATIC_SETTINGS['genetic_algorithm_parameters'].each_key.collect{ |key| key.to_sym }
      STATIC_SETTINGS['genetic_algorithm_parameters'].each_value.collect{ |val| val.to_i }.zip(keys) do |val, key|
        values[key] = val
      end
      record.scheduler_factors_table = SchedulerFactorsTable.create(values)
    end
  end

  has_many :divisions, :order => 'name ASC', :dependent => :destroy
  has_one :scheduler_factors_table, :dependent => :destroy
  accepts_nested_attributes_for :scheduler_factors_table
  accepts_nested_attributes_for :divisions

  validates_presence_of :unsatisfied_admit_threshold
  validates_numericality_of :unsatisfied_admit_threshold, :only_integer => true, :greater_than_or_equal_to => 0
  validates_inclusion_of :disable_faculty, :in => [true, false]
  validates_inclusion_of :disable_peer_advisors, :in => [true, false]

  def self.instance
    self.find(:all).first || self.send(:create)
  end

  def meeting_times(division_name)
    division = self.divisions.find_by_name(division_name)
    division.nil? ? nil : division.available_times
  end

  def method_missing(method, *args, &block)
    STATIC_SETTINGS[method.to_s] || super
  end
end
