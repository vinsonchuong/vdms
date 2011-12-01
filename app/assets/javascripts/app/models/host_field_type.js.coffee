class App.HostFieldType extends Spine.Model
  @configure 'HostFieldType', 'name', 'description', 'data_type', 'options'
  @extend Spine.Model.Ajax
  @url = ->
    Spine.Model.host + '/host_field_types'
