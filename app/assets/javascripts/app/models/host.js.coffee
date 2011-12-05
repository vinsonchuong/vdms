class App.Host extends Spine.Model
  @configure 'Host', 'person', 'fields'
  @extend Spine.Model.Ajax

  fromForm: (form) ->
    data = $(form).toObject(skipEmpty: false)
    @load($.extend(true, @attributes(), data))

  toJSON: ->
    data = @attributes()
    delete data.id
    data.fields_attributes = data.fields
    delete data.fields
    data.person_attributes = data.person
    delete data.person
    {host: data}
