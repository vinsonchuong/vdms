class VisitorRankingsController < RankingsController

  private

  def get_ranker
    Admit.find params[:admit_id]
  end

  def get_rankables
    Faculty
  end
end
