class Meeting < ActiveRecord::Base
  belongs_to :faculty
  has_and_belongs_to_many :admits

  validates_datetime :time
  validates_presence_of :room
  validates_existence_of :faculty

  validate :no_conflicts, :if => Proc.new { |m|  !m.admits.blank? }

  def self.generate
    MeetingsScheduler.delete_old_meetings!
    MeetingsScheduler.create_meetings_from_ranking_scores!
  end

  def to_s
    "Time: #{time.to_formatted_s(:long)}, faculty: #{faculty.full_name if faculty}, " <<
      "admits: #{admits.map { |a| a.full_name } if admits}"
  end

  def one_on_one_meeting?
    !(self.admits & self.faculty.ranked_one_on_one_admits).empty?
  end

  def add_admit!(admit)
    begin
      self.admits << admit
      self.save!
    rescue 
      self.admits -= [admit]
      raise
    end
  end

  def remove_admit!(admit)
    self.admits -= [admit]
    self.save!
  end

  private unless Rails.env == "test"

  def no_conflicts
    fn = faculty.full_name
    tm = time.strftime('%I:%M%p')
    errors.add_to_base "#{fn} has a 1-on-1 meeting with #{find_one_on_one_admit_ranking.admit.full_name} at #{tm}." if conflicts_with_one_on_one
    errors.add_to_base "#{fn} is already seeing #{@faculty.max_admits_per_meeting} people at #{tm}, which is his/her maximum." if exceeds_max_admits_per_meeting
    errors.add_to_base "#{fn} is not available at #{tm}." unless faculty.available_at?(time)
    unless admits.nil?
      admits.each do |admit|
        errors.add_to_base "#{admit.full_name} is not available at #{tm}." unless admit.available_at?(time)
        if (m = admit.meeting_at_time(time)) && m != self
          errors.add_to_base "#{admit.full_name} is already meeting with #{m.faculty.full_name} at #{tm}."
        end
      end
    end
  end

  def exceeds_max_admits_per_meeting
    self.admits.count > faculty.max_admits_per_meeting
  end

  def admit_unavailable(admit)
    unless
      errors.add_to_base("#{admit.full_name} is not available at #{time.strftime('%I:%M%p')}.")
    end
  end

  def conflicts_with_one_on_one
    # conflicts if faculty has a meeting at this same time with a "1 on 1" ranked candidate
    one_on_one_meeting? and admits.count > 1
  end

  def find_one_on_one_admit_ranking
    admit_ids = admits.collect{ |admit| admit.id }
    rankings = admit_ids.collect{ |id| faculty.admit_rankings.find_by_admit_id(id) }
    rankings.uniq.delete_if{ |r| r.nil? }.first
  end

end
