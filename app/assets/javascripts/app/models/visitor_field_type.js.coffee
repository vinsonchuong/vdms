class App.VisitorFieldType extends Spine.Model
  @configure 'VisitorFieldType', 'name', 'description', 'data_type', 'options'
  @extend Spine.Model.Ajax
  @url = ->
    Spine.Model.host + '/visitor_field_types'

  fromForm: (form) ->
    data = $(form).toObject(skipEmpty: false)
    radio_data = {}
    for d in $('input[type="radio"]:checked', form).toObject(mode: 'all', skipEmoty: false)
      $.extend(true, radio_data, d)
    @load($.extend(true, @attributes(), data, radio_data))

  toJSON: ->
    data = @attributes()
    delete data.id
    {visitor_field_type: data}
