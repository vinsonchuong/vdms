$ = jQuery.sub()
HostFieldType = App.HostFieldType

$.fn.item = ->
  elementID   = $(@).data('id')
  elementID or= $(@).parents('[data-id]').data('id')
  HostFieldType.find(elementID)

class New extends Spine.Controller
  events:
    'click [data-type=back]': 'back'
    'change input[name="data_type"]': 'update_options'
    'submit form': 'submit'
    
  constructor: ->
    super
    @active @render
    
  render: ->
    @html @view('host_field_types/new')
    @update_options()
    afterRender()

  back: ->
    @navigate '/'

  update_options: (e, data_type) ->
    data_type ?= $('input[name="data_type"]:checked', @el).val()
    $('#new_options', @el).html(@view("data_type_options/#{data_type}")(prefix: 'new'))
    if data_type in ['single_select', 'multiple_select']
      $('#new_options_selection_items', @el).listInput(inputName: ((pos) -> "options.selection_items[#{pos}]"))

  submit: (e) ->
    e.preventDefault()
    host_field_type = HostFieldType.fromForm(e.target).save()
    @navigate '/' if host_field_type

class Edit extends Spine.Controller
  events:
    'click [data-type=back]': 'back'
    'change input[name="data_type"]': 'update_options'
    'submit form': 'submit'

  constructor: ->
    super
    @active (params) ->
      @change(params.id)

  change: (id) ->
    @item = HostFieldType.find(id)
    @render()

  render: ->
    @html @view('host_field_types/edit')(host_field_type: @item)
    @update_options(null, @item.data_type)
    $('#edit', @el).fromObject(data: @item.attributes())
    afterRender()

  back: ->
    @navigate '/'

  update_options: (e, data_type) ->
    data_type ?= $('input[name="data_type"]:checked').val()
    $('#edit_options', @el).html(@view("data_type_options/#{data_type}")(prefix: 'edit'))
    if data_type in ['single_select', 'multiple_select']
      items = @item.options.selection_items or []
      $('#edit_options_selection_items', @el).listInput(inputName: ((pos) -> "options.selection_items[#{pos}]"), items: items)

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
    HostFieldType.bind 'refresh change', @render
    HostFieldType.fetch()

  render: =>
    host_field_types = HostFieldType.all()
    @html @view('host_field_types/index')(host_field_types: host_field_types)
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
      'Remove Host Field': ->
        item.destroy()
        $(this).dialog('close')
      'Cancel': ->
        $(this).dialog('close')
    )
    dialog.dialog('open')

  new: ->
    @navigate '/new'
    
class App.HostFieldTypes extends Spine.Stack
  controllers:
    index: Index
    edit:  Edit
    new:   New
    
  routes:
    '/new':      'new'
    '/:id/edit': 'edit'
    '/':         'index'

  default: 'index'
  className: 'stack host_field_types'
