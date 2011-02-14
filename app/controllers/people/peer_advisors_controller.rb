class PeerAdvisorsController < PeopleController
  # GET /people/peer_advisors/1/new
  def new
    if @current_user.new_record?
      @peer_advisor = @current_user
    else
      @peer_advisor = PeerAdvisor.new
    end
  end

  # POST /people/peer_advisors
  def create
    @peer_advisor = PeerAdvisor.new(params[:peer_advisor])
    @peer_advisor.ldap_id = @current_user.ldap_id if @current_user.new_record?

    if @peer_advisor.save
      redirect_to(peer_advisors_url, :notice => 'Peer Advisor was successfully added.')
    else
      render :action => 'new'
    end
  end

  private

  def set_model
    @model = PeerAdvisor
  end
end
