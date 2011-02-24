class PeerAdvisorsController < PeopleController
  # GET /people/peer_advisors/1/new
  def new
    @peer_advisor = (@current_user.new_record?) ? @current_user : PeerAdvisor.new
  end

  private

  def get_model
    @model = PeerAdvisor
    @collection = 'peer_advisors'
    @instance = 'peer_advisor'
  end
end
