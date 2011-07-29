class HostRankingsController < RankingsController

  private

  def get_ranker
    Faculty.find params[:faculty_instance_id]
  end

  def get_rankables
    Admit
  end
end
