$ = jQuery.sub()
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
    @html @view('visitor/new')(visitor: @item)
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
    @html @view('visitors/edit')(visitor: @item)
    $('#edit').fromObject(data: @item.attributes())
    afterRender()

  back: ->
    @navigate '/'

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
    Visitor.bind 'refresh change', @render
    Visitor.fetch()
    VisitorFieldType.fetch()

  render: =>
    visitors = Visitor.all()
    @html @view('visitors/index')(visitors: visitors)
    afterRender()

  edit: (e) ->
    item = $(e.target).item()
    @navigate '', item.id, 'edit'
    
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
    
class App.Visitor extends Spine.Stack
  controllers:
    index: Index
    edit:  Edit
    new:   New
    
  routes:
    '/new':      'new'
    '/:id/edit': 'edit'
    '/':         'index'
    
  default: 'index'
  className: 'stack visitors'
