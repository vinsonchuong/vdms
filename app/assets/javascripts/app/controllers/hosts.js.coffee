$ = jQuery.sub()
Host = App.Host

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

  back: ->
    @navigate '/hosts'

  submit: (e) ->
    e.preventDefault()
    host = Host.fromForm(e.target).save()
    @navigate '/hosts', host.id if host

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
    @html @view('hosts/edit')(@item)

  back: ->
    @navigate '/hosts'

  submit: (e) ->
    e.preventDefault()
    @item.fromForm(e.target).save()
    @navigate '/hosts'

class Show extends Spine.Controller
  events:
    'click [bata-type=edit]': 'edit'
    'click [data-type=back]': 'back'

  constructor: ->
    super
    @active (params) ->
      @change(params.id)

  change: (id) ->
    @item = Host.find(id)
    @render()

  render: ->
    @html @view('hosts/show')(@item)

  edit: ->
    @navigate '/hosts', @item.id, 'edit'

  back: ->
    @navigate '/hosts'

class Index extends Spine.Controller
  events:
    'click [data-type=edit]':    'edit'
    'click [data-type=destroy]': 'destroy'
    'click [data-type=show]':    'show'
    'click [data-type=new]':     'new'

  constructor: ->
    super
    Host.bind 'refresh change', @render
    Host.fetch()
    
  render: =>
    hosts = Host.all()
    @html @view('hosts/index')(hosts: hosts)
    
  edit: (e) ->
    item = $(e.target).item()
    @navigate '/hosts', item.id, 'edit'
    
  destroy: (e) ->
    item = $(e.target).item()
    item.destroy() if confirm('Sure?')
    
  show: (e) ->
    item = $(e.target).item()
    @navigate '/hosts', item.id
    
  new: ->
    @navigate '/hosts/new'
    
class App.Hosts extends Spine.Stack
  controllers:
    index: Index
    edit:  Edit
    show:  Show
    new:   New
    
  routes:
    '/hosts/new':      'new'
    '/hosts/:id/edit': 'edit'
    '/hosts/:id':      'show'
    '/hosts':          'index'
    
  default: 'index'
  className: 'stack hosts'
