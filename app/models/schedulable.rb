module Schedulable
  def self.included(base)
    base.has_many :available_times, :as => :schedulable, :dependent => :destroy

    base.validate do |record| # non-overlapping Available Meeting Times
      record.available_times.combination(2) do |times|
        if times[0].overlap?(times[1])
          record.errors.add_to_base('Available times must not overlap')
          break
        end
      end
    end
  end
end
