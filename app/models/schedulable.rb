module Schedulable
  def self.included(base)
    base.has_many :available_times, :as => :schedulable, :order => 'begin ASC', :dependent => :destroy
    base.accepts_nested_attributes_for :available_times, :reject_if => :all_blank, :allow_destroy => true

    base.validate do |record| # non-overlapping Available Meeting Times
      record.available_times.combination(2) do |times|
        if [times[0].begin, times[0].end, times[1].begin, times[1].end].all? && times[0].overlap?(times[1])
          record.errors.add_to_base('Available times must not overlap')
          break
        end
      end
    end
  end
end
