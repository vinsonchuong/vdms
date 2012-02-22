$ = jQuery.sub()
TimeSlot = App.TimeSlot
Host = App.Host
Visitor = App.Visitor
VisitorFieldType = App.VisitorFieldType

$.fn.item = ->
  elementID   = $(@).data('id')
  elementID or= $(@).parents('[data-id]').data('id')
  Visitor.find(elementID)

class New extends Spine.Controller
  events:
    'click [data-type=back]': 'back'
    'submit form': 'submit'
    
  constructor: ->
    super
    @active @render
    
  render: ->
    @item = new Visitor
    @html @view('visitors/new')(
      helper:
        render_data_type: (data_type, params) =>
          @view("data_type_input/" + data_type)(params)
      visitor: @item
    )
    $('#new').fromObject(data: Visitor.new_attributes)
    afterRender()

  back: ->
    @navigate '/'

  submit: (e) ->
    e.preventDefault()
    visitor = Visitor.fromForm(e.target).save()
    @navigate '/' if visitor

class Edit extends Spine.Controller
  events:
    'click [data-type=back]': 'back'
    'submit form': 'submit'

  constructor: ->
    super
    @active (params) ->
      @change(params.id)

  change: (id) ->
    @item = Visitor.find(id)
    @render()

  render: ->
    @html @view('visitors/edit')(
      helper:
        render_data_type: (data_type, params) =>
          @view("data_type_input/" + data_type)(params)
      visitor: @item
    )
    $('#edit').fromObject(data: @item.attributes())
    afterRender()

  back: ->
    @navigate '/'

  submit: (e) ->
    e.preventDefault()
    @item.fromForm(e.target).save()
    @navigate '/'

class EditAvailabilities extends Spine.Controller
  events:
    'click [data-type=back]': 'back'
    'submit form': 'submit'
  
  constructor: ->
    super
    @active (params) ->
      @change(params.id)
      
  change: (id) ->
    @item = Visitor.find(id)
    @render()

  render: ->
    @html @view('visitors/edit_availabilities')(visitor: @item)
    $('#edit_availabilities').fromObject(data: @item.attributes())
    afterRender()

  back: ->
    @navigate '/'

  submit: (e) ->
    e.preventDefault()
    @item.fromForm(e.target).save()
    @navigate '/'

class Index extends Spine.Controller
  events:
    'click [data-type=edit]': 'edit'
    'click [data-type=edit_availabilities]': 'edit_availabilities'
    'click [data-type=destroy]': 'destroy'
    'click [data-type=new]': 'new'

  constructor: ->
    super
    showSpinner()
    Visitor.bind 'refresh change', @render
    TimeSlot.fetch()
    Host.fetch()
    Visitor.fetch()
    VisitorFieldType.fetch()

  render: =>
    visitors = Visitor.all()
    @html @view('visitors/index')(visitors: visitors)
    $('#confirm_delete').dialog(
      autoOpen: false
      modal: true
      resizable: false
    )
    afterRender()
    hideSpinner()

  edit: (e) ->
    item = $(e.target).item()
    @navigate '', item.id, 'edit'

  edit_availabilities: (e) ->
    item = $(e.target).item()
    @navigate '', item.id, 'edit_availabilities'

  destroy: (e) ->
    item = $(e.target).item()
    dialog = $('#confirm_delete')
    dialog.dialog('option', 'buttons',
      'Remove Visitor': ->
        item.destroy()
        $(this).dialog('close')
      'Cancel': ->
        $(this).dialog('close')
    )
    dialog.dialog('open')

  new: ->
    @navigate '/new'

class App.Visitors extends Spine.Stack
  controllers:
    index: Index
    edit: Edit
    edit_availabilities: EditAvailabilities
    new: New
    
  routes:
    '/new': 'new'
    '/:id/edit': 'edit'
    '/:id/edit_availabilities': 'edit_availabilities'
    '/': 'index'
    
  default: 'index'
  className: 'stack visitors'
