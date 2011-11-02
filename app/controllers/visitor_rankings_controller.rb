class VisitorRankingsController < RankingsController

  private

  def get_ranker
    @event.visitors.find params[:visitor_id]
  end

  def get_rankables
    @event.hosts
  end
end
