class HostRankingsController < RankingsController

  private

  def get_ranker
    Host.find params[:host_id]
  end

  def get_rankables
    Visitor
  end
end
