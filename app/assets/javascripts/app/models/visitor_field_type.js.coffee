class App.VisitorFieldType extends Spine.Model
  @configure 'VisitorFieldType', 'name', 'description', 'data_type', 'options'
  @extend Spine.Model.Ajax
  @url = ->
    Spine.Model.host + '/visitor_field_types'

  fromForm: (form) ->
    data = $(form).toObject()
    @load(data)

  toJSON: ->
    data = @attributes()
    delete data.id
    {visitor_field_type: data}
