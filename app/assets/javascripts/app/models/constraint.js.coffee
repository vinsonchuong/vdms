class App.Constraint extends Spine.Model
  @configure 'Constraint', 'name', 'feature_type', 'options', 'host_field_type_id', 'visitor_field_type_id'
  @extend Spine.Model.Ajax

  fromForm: (form) ->
    data = $(form).toObject()
    @load(data)

  toJSON: ->
    data = @attributes()
    delete data.id
    {constraint: data}
