class App.Visitor extends Spine.Model
  @configure 'Visitor', 'person', 'availabilities', 'rankings', 'fields'
  @extend Spine.Model.Ajax

  @new_attributes: {}

  @fetch: (params) ->
    $.getJSON(@url() + '/new', (data) => @new_attributes = data)
    super(params)

  @create: (attrs) ->
    attrs = $.extend(true, @new_attributes, attrs)
    super(attrs)

  constructor: (attrs = {}) ->
    super($.extend(true, {}, App.Visitor.new_attributes, attrs))

  fromForm: (form) ->
    data = $(form).toObject()
    @load(data)

  toJSON: ->
    data = @attributes()

    if data.availabilities?
      for availability in data.availabilities
        if not availability.available?
          availability.available = false

    delete data.id
    data.person_attributes = data.person
    delete data.person
    data.availabilities_attributes = data.availabilities
    delete data.availabilities
    data.rankings_attributes = data.rankings
    delete data.rankings
    data.fields_attributes = data.fields
    delete data.fields
    {visitor: data}
