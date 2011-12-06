$ = jQuery.sub()
Constraint = App.Constraint
HostFieldType = App.HostFieldType
VisitorFieldType = App.VisitorFieldType

$.fn.item = ->
  elementID   = $(@).data('id')
  elementID or= $(@).parents('[data-id]').data('id')
  Constraint.find(elementID)

class New extends Spine.Controller
  events:
    'click [data-type=back]': 'back'
    'change #new_host_field_type_id': 'update_feature_types'
    'change #new_visitor_field_type_id': 'update_feature_types'
    'change input[name=feature_type]': 'update_options'
    'submit form': 'submit'
    
  constructor: ->
    super
    @active @render
    
  render: ->
    host_field_types = HostFieldType.all()
    visitor_field_types = VisitorFieldType.all()
    @html @view('constraints/new')(host_field_types: host_field_types, visitor_field_types: visitor_field_types)
    @update_feature_types()
    @update_options()
    afterRender()

  back: ->
    @navigate '/'

  update_feature_types: (e, host_data_type, visitor_data_type) ->
    unless host_data_type? and visitor_data_type?
      host_data_type = HostFieldType.find($('#new_host_field_type_id').val()).data_type
      visitor_data_type = VisitorFieldType.find($('#new_visitor_field_type_id').val()).data_type
    if host_data_type == 'multiple_select' and visitor_data_type == 'multiple_select'
      feature_types = [
        {name: 'They should overlap.', value: 'intersect'},
        {name: 'They should not overlap.', value: 'not_intersect'},
        {name: 'They should be the same.', value: 'equal'},
        {name: 'They should not be the same.', value: 'not_equal'},
        {name: 'They should have specific combinations', value: 'combination'}
      ]
    else if (host_data_type == 'multiple_select' and visitor_data_type == 'single_select') or
            (host_data_type == 'single_select' and visitor_data_type == 'multiple_select')
      feature_types = [
        {name: 'They should overlap.', value: 'intersect'},
        {name: 'They should not overlap.', value: 'not_intersect'}
        {name: 'They should have specific combinations', value: 'combination'}
      ]
    else if host_data_type == 'single_select' and visitor_data_type == 'single_select'
      feature_types = [
        {name: 'They should be the same.', value: 'equal'},
        {name: 'They should not be the same.', value: 'not_equal'},
        {name: 'They should have specific combinations', value: 'combination'}
      ]
    else
      feature_types = [
        {name: 'They should be the same.', value: 'equal'},
        {name: 'They should not be the same.', value: 'not_equal'}
      ]
    $('#new_feature_types', @el).html(@view("feature_type_options/feature_types")(
      id_prefix: 'new_host',
      feature_types: feature_types
    ))

  update_options: (e, feature_type) ->
    feature_type ?= $('input[name=feature_type]:checked', @el).val()
    host_field_type = HostFieldType.find($('#new_host_field_type_id').val())
    visitor_field_type = VisitorFieldType.find($('#new_visitor_field_type_id').val())
    $('#new_options', @el).html(@view("feature_type_options/#{feature_type}")(
      prefix: 'new',
      host_field_type: host_field_type,
      visitor_field_type: visitor_field_type
    ))
    if feature_type == 'combination'
      $('#new_options input[type=checkbox]').change((e) ->
        $target = $(e.target)
        if $target.is(':checked')
          $target.siblings('input[type=hidden]').removeAttr('disabled')
        else
          $target.siblings('input[type=hidden]').attr('disabled', 'disabled')
      )

  submit: (e) ->
    e.preventDefault()
    constraint = Constraint.fromForm(e.target).save()
    @navigate '/' if constraint

class Edit extends Spine.Controller
  events:
    'click [data-type=back]': 'back'
    'change #edit_host_field_type_id': 'update_feature_types'
    'change #edit_visitor_field_type_id': 'update_feature_types'
    'change input[name=feature_type]': 'update_options'
    'submit form': 'submit'

  constructor: ->
    super
    @active (params) ->
      @change(params.id)

  change: (id) ->
    @item = Constraint.find(id)
    @render()

  render: ->
    host_field_types = HostFieldType.all()
    visitor_field_types = VisitorFieldType.all()
    @html @view('constraints/edit')(constraint: @item, host_field_types: host_field_types, visitor_field_types: visitor_field_types)
    $('#edit', @el).fromObject(data: @item.attributes())
    @update_feature_types()
    $('#edit', @el).fromObject(data: @item.attributes())
    @update_options()
    afterRender()

  back: ->
    @navigate '/'

  update_feature_types: (e, host_data_type, visitor_data_type) ->
    unless host_data_type? and visitor_data_type?
      host_data_type = HostFieldType.find($('#edit_host_field_type_id').val()).data_type
      visitor_data_type = VisitorFieldType.find($('#edit_visitor_field_type_id').val()).data_type
    if host_data_type == 'multiple_select' and visitor_data_type == 'multiple_select'
      feature_types = [
        {name: 'They should overlap.', value: 'intersect'},
        {name: 'They should not overlap.', value: 'not_intersect'},
        {name: 'They should be the same.', value: 'equal'},
        {name: 'They should not be the same.', value: 'not_equal'},
        {name: 'They should have specific combinations', value: 'combination'}
      ]
    else if (host_data_type == 'multiple_select' and visitor_data_type == 'single_select') or
            (host_data_type == 'single_select' and visitor_data_type == 'multiple_select')
      feature_types = [
        {name: 'They should overlap.', value: 'intersect'},
        {name: 'They should not overlap.', value: 'not_intersect'}
        {name: 'They should have specific combinations', value: 'combination'}
      ]
    else if host_data_type == 'single_select' and visitor_data_type == 'single_select'
      feature_types = [
        {name: 'They should be the same.', value: 'equal'},
        {name: 'They should not be the same.', value: 'not_equal'},
        {name: 'They should have specific combinations', value: 'combination'}
      ]
    else
      feature_types = [
        {name: 'They should be the same.', value: 'equal'},
        {name: 'They should not be the same.', value: 'not_equal'}
      ]
    $('#edit_feature_types', @el).html(@view("feature_type_options/feature_types")(
      id_prefix: 'edit_constraint',
      feature_types: feature_types
    ))

  update_options: (e, feature_type) ->
    feature_type ?= $('input[name=feature_type]:checked').val()
    host_field_type = HostFieldType.find($('#edit_host_field_type_id').val())
    visitor_field_type = VisitorFieldType.find($('#edit_visitor_field_type_id').val())
    $('#edit_options', @el).html(@view("feature_type_options/#{feature_type}")(
      prefix: 'edit',
      host_field_type: host_field_type,
      visitor_field_type: visitor_field_type,
      feature: @item
    ))
    if feature_type == 'combination'
      $('#edit_options input[type=checkbox]', @el).change((e) ->
        $target = $(e.target)
        if $target.is(':checked')
          $target.siblings('input[type=hidden]').removeAttr('disabled')
        else
          $target.siblings('input[type=hidden]').attr('disabled', 'disabled')
      )

  submit: (e) ->
    e.preventDefault()
    @item.fromForm(e.target).save()
    @navigate '/'

class Index extends Spine.Controller
  events:
    'click [data-type=edit]':    'edit'
    'click [data-type=destroy]': 'destroy'
    'click [data-type=new]':     'new'

  constructor: ->
    super
    Constraint.bind 'refresh change', @render
    Constraint.fetch()
    HostFieldType.fetch()
    VisitorFieldType.fetch()

  render: =>
    constraints = Constraint.all()
    @html @view('constraints/index')(constraints: constraints)
    $('#confirm_delete').dialog(
      autoOpen: false
      modal: true
      resizable: false
    )
    afterRender()

  edit: (e) ->
    item = $(e.target).item()
    @navigate '', item.id, 'edit'
    
  destroy: (e) ->
    item = $(e.target).item()
    dialog = $('#confirm_delete')
    dialog.dialog('option', 'buttons',
      'Remove Constraint': ->
        item.destroy()
        $(this).dialog('close')
      'Cancel': ->
        $(this).dialog('close')
    )
    dialog.dialog('open')

  new: ->
    @navigate '/new'
    
class App.Constraints extends Spine.Stack
  controllers:
    index: Index
    edit:  Edit
    new:   New
    
  routes:
    '/new':      'new'
    '/:id/edit': 'edit'
    '/':         'index'

  default: 'index'
  className: 'stack constraints'
