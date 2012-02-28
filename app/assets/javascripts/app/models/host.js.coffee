class App.Host extends Spine.Model
  @configure 'Host', 'person', 'availabilities', 'rankings', 'fields', 'location', 'location_id', 'default_room', 'default_building', 'max_visitors_per_meeting', 'max_visitors'
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

    if data.availabilities?
      for availability in data.availabilities
        if not availability.available?
          availability.available = false

    if data.rankings?
      for ranking in data.rankings
        if not ranking.mandatory?
          ranking.mandatory = false
        if not ranking.one_on_one?
          ranking.one_on_one = false

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

  validate: ->
    'Please enter a default meeting location.' if @default_room == 'None'
