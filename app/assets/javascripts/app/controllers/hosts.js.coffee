$ = jQuery.sub()
Host = App.Host
HostFieldType = App.HostFieldType

$.fn.item = ->
  elementID   = $(@).data('id')
  elementID or= $(@).parents('[data-id]').data('id')
  Host.find(elementID)

class New extends Spine.Controller
  events:
    'click [data-type=back]': 'back'
    'submit form': 'submit'
    
  constructor: ->
    super
    @active @render
    
  render: ->
    @html @view('hosts/new')
    afterRender()

  back: ->
    @navigate '/'

  submit: (e) ->
    e.preventDefault()
    host = Host.fromForm(e.target).save()
    @navigate '/' if host

class Edit extends Spine.Controller
  events:
    'click [data-type=back]': 'back'
    'submit form': 'submit'
  
  constructor: ->
    super
    @active (params) ->
      @change(params.id)
      
  change: (id) ->
    @item = Host.find(id)
    @render()

  render: ->
    @html @view('hosts/edit')(host: @item)
    $('#edit_host_form').fromObject(data: @item.attributes())
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
    Host.bind 'refresh change', @render
    Host.fetch()
    HostFieldType.fetch()
    
  render: =>
    hosts = Host.all()
    @html @view('hosts/index')(hosts: hosts)
    afterRender()

  edit: (e) ->
    item = $(e.target).item()
    @navigate '', item.id, 'edit'
    
  destroy: (e) ->
    item = $(e.target).item()
    item.destroy() if confirm('Sure?')
    
  new: ->
    @navigate '/new'
    
class App.Hosts extends Spine.Stack
  controllers:
    index: Index
    edit:  Edit
    new:   New
    
  routes:
    '/new':      'new'
    '/:id/edit': 'edit'
    '/':         'index'
    
  default: 'index'
  className: 'stack hosts'
