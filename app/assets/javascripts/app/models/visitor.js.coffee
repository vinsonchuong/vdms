class App.Visitor extends Spine.Model
  @configure 'Visitor', 'availabilities', 'person', 'fields'
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
    data.availabilities_attributes = data.availabilities
    delete data.availabilities
    data.fields_attributes = data.fields
    delete data.fields
    data.person_attributes = data.person
    delete data.person
    {visitor: data}
