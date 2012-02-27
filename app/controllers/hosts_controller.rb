class HostsController < RolesController

  private

  def get_role(attributes = {})
    if !params[:id].nil?
      @event.hosts.find(params[:id])
    elsif !params[:host].nil?
      @event.hosts.build(params[:host].merge!(attributes))
    else
      @event.hosts.build(attributes)
    end
  end

  def create_role(attributes = {})
    @event.hosts.create(attributes)
  end

  def get_roles
    @event.hosts
  end

  def get_attributes
    params[:host] || {}
  end

  def get_i18n_scope
    :hosts
  end

  def get_csv_columns()
    names = ['Last Name', 'First Name', 'Email', 'Phone', 'Location']
    spans = {}
    @event.host_field_types.each do |field_type|
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
