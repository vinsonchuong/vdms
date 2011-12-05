class App.HostFieldType extends Spine.Model
  @configure 'HostFieldType', 'name', 'description', 'data_type', 'options'
  @extend Spine.Model.Ajax
  @url = ->
    Spine.Model.host + '/host_field_types'

  fromForm: (form) ->
    data = $(form).toObject(skipEmpty: false)
    radio_data = {}
    for d in $('input[type="radio"]:checked', form).toObject(mode: 'all', skipEmoty: false)
      $.extend(true, radio_data, d)
    @load($.extend(true, @attributes(), data, radio_data))

  toJSON: ->
    data = @attributes()
    delete data.id
    {host_field_type: data}
