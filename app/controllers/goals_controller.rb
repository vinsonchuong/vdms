class GoalsController < FeaturesController
  private

  def get_features
    @event.goals
  end

  def get_feature(attributes = {})
    if !params[:id].nil?
      @event.goals.find(params[:id])
    elsif !params[:goal].nil?
      @event.goals.build(params[:goal].merge!(attributes))
    else
      @event.goals.build(attributes)
    end
  end

  def get_attributes
    params[:goal]
  end

  def get_i18n_scope
    :goals
  end

  def get_view_path
    '/goals'
  end
end
