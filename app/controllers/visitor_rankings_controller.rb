class VisitorRankingsController < RankingsController

  private

  def get_ranker
    Visitor.find params[:visitor_id]
  end

  def get_rankables
    Host
  end
end
