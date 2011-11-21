class RankingsController < EventBaseController
  # GET /events/1/hosts/1/rankings
  # GET /events/1/visitors/1/rankings
  def index
    @ranker = get_ranker
  end

  # GET /events/1/hosts/1/rankings/add
  # GET /events/1/visitors/1/rankings/add
  def add
    @ranker = get_ranker
    @rankables = get_rankables - @ranker.rankings.map(&:rankable)
  end

  # GET /events/1/hosts/1/rankings/edit_all
  # GET /events/1/visitors/1/rankings/edit_all
  def edit_all
    @ranker = get_ranker

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
      render 'edit_all'
    end
  end
end
