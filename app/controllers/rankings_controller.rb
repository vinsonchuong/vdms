class RankingsController < ApplicationController
  # GET /people/PEOPLE/1/rankings
  def index
    @ranker = get_ranker
  end

  # GET /people/PEOPLE/1/rankings/add
  def add
    @ranker = get_ranker
    @settings = Settings.instance
    if params[:filter].nil?
      @areas = @settings.areas.keys.sort!.map {|a| [a, true]}
      @rankables = get_rankables.all # Pull into model
    else
      @areas = params[:filter].update_values(&:to_b).to_a.sort
      filter_areas = @areas.select {|a, c| c}.map(&:first)
      @rankables = get_rankables.with_areas(*filter_areas)
    end
    @rankables -= @ranker.rankings.map(&:rankable)
  end

  # GET /people/PEOPLE/1/rankings/edit_all
  def edit_all
    @ranker = get_ranker
    @settings = Settings.instance

    unless params[:select].nil?
      get_rankables.find(
          params[:select].select {|r, c| c.to_b}.map(&:first)
      ).each do |r|
        @ranker.rankings.build(:rankable => r, :rank => 1)
      end
    end

    if @settings.disable_faculty && @current_user.class == Faculty ||
       @settings.disable_peer_advisors && @current_user.class == PeerAdvisor
      flash[:alert] = t('rankings.edit_all.disabled')
    end

    redirect_to :action => 'add' if @ranker.rankings.empty?
  end

  # PUT /people/PEOPLE/1/rankings/update_all
  def update_all
    # Grab redirect logic from edit_all as well
    @ranker = get_ranker
    if @ranker.update_attributes(params[@ranker.class.name.underscore.to_sym])
      flash[:notice] = t(:success, :scope => [:people, @ranker.class.name.tableize, :update])
      redirect_to :action => 'edit_all'
    else
      render 'edit_all'
    end
  end
end
