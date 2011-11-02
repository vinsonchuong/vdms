class HostRankingsController < RankingsController

  private

  def get_ranker
    @event.hosts.find params[:host_id]
  end

  def get_rankables
    @event.visitors
  end
end
