class ConstraintsController < FeaturesController
  private

  def get_features
    @event.constraints
  end

  def get_feature(attributes = {})
    if !params[:id].nil?
      @event.constraints.find(params[:id])
    elsif !params[:constraint].nil?
      @event.constraints.build(params[:constraint].merge!(attributes))
    else
      @event.constraints.build(attributes)
    end
  end

  def get_attributes
    params[:constraint]
  end

  def get_i18n_scope
    :constraints
  end

  def get_view_path
    '/constraints'
  end
end
