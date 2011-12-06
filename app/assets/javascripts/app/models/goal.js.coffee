class App.Goal extends Spine.Model
  @configure 'Goal', 'name', 'weight', 'feature_type', 'options', 'host_field_type_id', 'visitor_field_type_id'
  @extend Spine.Model.Ajax

  fromForm: (form) ->
    data = $(form).toObject()
    @load(data)

  toJSON: ->
    data = @attributes()
    delete data.id
    {goal: data}
