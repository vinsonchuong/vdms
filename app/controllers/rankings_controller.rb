class RankingsController < ApplicationController
  # GET /events/1/hosts/1/rankings
  # GET /events/1/visitors/1/rankings
  def index
    @event = Event.find(params[:event_id])
    @ranker = get_ranker
  end

  # GET /events/1/hosts/1/rankings/add
  # GET /events/1/visitors/1/rankings/add
  def add
    @event = Event.find(params[:event_id])
    @ranker = get_ranker
    if params[:filter].nil?
      @areas = Person.areas.keys.sort!.map {|a| [a, true]}
      @rankables = get_rankables.all # Pull into model
    else
      @areas = params[:filter].update_values(&:to_b).to_a.sort
      filter_areas = @areas.select {|a, c| c}.map(&:first)
      @rankables = get_rankables.with_areas(*filter_areas)
    end
    @rankables -= @ranker.rankings.map(&:rankable)
  end

  # GET /events/1/hosts/1/rankings/edit_all
  # GET /events/1/visitors/1/rankings/edit_all
  def edit_all
    @ranker = get_ranker
    @event = Event.find(params[:event_id])

    unless params[:select].nil?
      get_rankables.find(
          params[:select].select {|r, c| c.to_b}.map(&:first)
      ).each do |r|
        @ranker.rankings.build(:rankable => r, :rank => 1)
      end
    end

    if @event.disable_hosts? && !@event.hosts.find_by_person_id(@current_user.id).nil? ||
        @event.disable_facilitators? && @current_user.role == 'facilitator'
      flash[:alert] = t('rankings.edit_all.disabled')
    end

    redirect_to :action => 'add' if @ranker.rankings.empty?
  end

  # PUT /events/1/hosts/1/rankings/update_all
  # PUT /events/1/visitors/1/rankings/update_all
  def update_all
    # Grab redirect logic from edit_all as well
    @ranker = get_ranker
    if @ranker.update_attributes(params[@ranker.class.name.underscore.to_sym])
      flash[:notice] = t(:success, :scope => [@ranker.class.name.tableize, :update])
      redirect_to :action => 'edit_all'
    else
      @event = Event.find(params[:event_id])
      render 'edit_all'
    end
  end
end
