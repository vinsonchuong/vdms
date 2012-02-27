class VisitorsController < RolesController

  private

  def get_role(attributes = {})
    if !params[:id].nil?
      @event.visitors.find(params[:id])
    elsif !params[:visitor].nil?
      @event.visitors.build(params[:visitor].merge!(attributes))
    else
      @event.visitors.build(attributes)
    end
  end

  def create_role(attributes = {})
    @event.visitors.create(attributes)
  end

  def get_roles
    @event.visitors
  end

  def get_attributes
    params[:visitor] || {}
  end

  def get_i18n_scope
    :visitors
  end

  def get_csv_columns()
    spans = {}
    names = ['Last Name', 'First Name', 'Email', 'Phone']
    @event.visitor_field_types.each do |field_type|
      if ['multiple_select', 'hosts', 'visitors'].include? field_type.data_type
        num = field_type.fields.map {|f| (not f.data.blank? and f.data['answer'].is_a?(Array)) ?
                                           f.data['answer'].length :
                                           0}.max
        names.concat((1..num).map {|i| field_type.name + ' ' + i.to_s})
        spans[field_type.name] = num
      else
        names << field_type.name
      end
      if field_type.options['comment'] == 'yes'
        names << field_type.name + ' - ' + 'Comments'
      end
    end
    [names, spans]
  end
end
