class App.VisitorFieldType extends Spine.Model
  @configure 'VisitorFieldType', 'name', 'description', 'data_type', 'options'
  @extend Spine.Model.Ajax
  @url = ->
    Spine.Model.host + '/host_field_types'

