class App.Host extends Spine.Model
  @configure 'Host', 'person', 'availabilities', 'rankings', 'fields', 'location', 'location_id', 'default_room', 'max_visitors_per_meeting', 'max_visitors'
  @extend Spine.Model.Ajax

  @new_attributes: {}

  @fetch: (params) ->
    $.getJSON(@url() + '/new', (data) => @new_attributes = data)
    super(params)

  @create: (attrs) ->
    attrs = $.extend(true, @new_attributes, attrs)
    super(attrs)

  constructor: (attrs = {}) ->
    super($.extend(true, {}, App.Host.new_attributes, attrs))

  fromForm: (form) ->
    data = $(form).toObject()
    @load(data)

  toJSON: ->
    data = @attributes()
    delete data.id
    data.person_attributes = data.person
    delete data.person
    data.availabilities_attributes = data.availabilities
    delete data.availabilities
    data.rankings_attributes = data.rankings
    delete data.rankings
    data.fields_attributes = data.fields
    delete data.fields
    {host: data}
