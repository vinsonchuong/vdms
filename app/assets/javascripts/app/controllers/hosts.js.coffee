$ = jQuery.sub()
TimeSlot = App.TimeSlot
Host = App.Host
HostFieldType = App.HostFieldType
Visitor = App.Visitor

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
    @item = new Host
    @html @view('hosts/new')(
      helper:
        render_data_type: (data_type, params) =>
          @view("data_type_input/" + data_type)(params)
      host: @item
    )
    $('#new').fromObject(data: Host.new_attributes)
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
    @html @view('hosts/edit')(
      helper:
        render_data_type: (data_type, params) =>
          @view("data_type_input/" + data_type)(params)
      host: @item
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
    @item = Host.find(id)
    @render()

  render: ->
    @html @view('hosts/edit_availabilities')(host: @item)
    $('#edit_availabilities').fromObject(data: @item.attributes())
    afterRender()

  back: ->
    @navigate '/'

  submit: (e) ->
    e.preventDefault()
    @item.fromForm(e.target).save()
    @navigate '/'

class EditRankings extends Spine.Controller
  events:
    'click [data-type=add_rankings]': 'add_rankings'
    'click [data-type=back]': 'back'
    'submit form': 'submit'
    'change input.destroy': 'reorder'

  constructor: ->
    super
    @active (params) ->
      if params.data
        @data = params.data
        @render()
        @reorder()
      else
        @change(params.id)

  change: (id) ->
    @item = Host.find(id)
    @data = @item.attributes()
    @render()

  render: ->
    @html @view('hosts/edit_rankings')(host: @data)
    $('#edit_rankings').fromObject(data: @data)
    $('#edit_rankings tbody').sortable(
      update: => @reorder()
    )
    afterRender()

  reorder: ->
    i = 1
    $('#edit_rankings tbody').children().each(->
        if $('input.destroy', this).prop('checked')
          $('span.rank', this).text(' ')
          $('input.rank', this).val(' ')
        else
          $('span.rank', this).text(i)
          $('input.rank', this).val(i)
          i += 1
    )

  add_rankings: ->
    @data = $('#edit_rankings').toObject()
    @navigate '', @item.id, 'add_rankings', data: @data

  back: ->
    @navigate '/'

  submit: (e) ->
    e.preventDefault()
    showSpinner()
    @item.fromForm(e.target).save()
    Host.fetch({id: @item.id})
    @navigate '/'

class AddRankings extends Spine.Controller
  events:
    'click [data-type=back]': 'back'
    'click [data-type=submit]': 'submit'
    'change #area_filter': 'filter'
    'multiselectcheckall #area_filter': 'filter'
    'multiselectuncheckall #area_filter': 'filter'

  constructor: ->
    super
    @active (params) ->
      @data = params.data
      @change(params.id)

  change: (id) ->
    @item = Host.find(id)
    @ranked = {}
    if not @data.rankings?
      @data.rankings = []
    for ranking in @data.rankings
      @ranked[ranking.rankable_id] = true
    @rankables = Visitor.select((v) => not @ranked[v.id])
    @areas = HostFieldType.first().options.selection_items
    @render()

  render: ->
    @html @view('hosts/add_rankings')(host: @data, rankables: @rankables, areas: @areas)
    $('#add_rankings tbody').html(@view('hosts/rankables')(rankables: @rankables))
    afterRender()
    $('select#area_filter').multiselect(
      noneSelectedText: 'Filter by Area',
      selectedList: 6,
    ).multiselectfilter()

  back: ->
    @navigate '', @item.id, 'edit_rankings', data: @data

  submit: () ->
    rankables = $('#add_rankings').toObject().rankables
    if rankables?
      for rankable_id in rankables
        @data.rankings.push(
          rankable_id: rankable_id
        )
      @navigate '', @item.id, 'edit_rankings', data: @data

  filter: () ->
    areas = $('#area_filter').val()
    if areas? and areas.length
      areas_lookup = {}
      for area in areas
        areas_lookup[area] = true
      @rankables = Visitor.select((v) =>
        not @ranked[v.id] and v.fields[0].data? and areas_lookup[v.fields[0].data.answer]
      )
    else
      @rankables = Visitor.select((v) => not @ranked[v.id])
    $('#add_rankings tbody').html(@view('hosts/rankables')(rankables: @rankables))

class Index extends Spine.Controller
  events:
    'click [data-type=edit]': 'edit'
    'click [data-type=edit_availabilities]': 'edit_availabilities'
    'click [data-type=edit_rankings]': 'edit_rankings'
    'click [data-type=destroy]': 'destroy'
    'click [data-type=new]': 'new'

  constructor: ->
    super
    showSpinner()
    Host.bind 'refresh change', @render
    TimeSlot.fetch()
    Host.fetch()
    HostFieldType.fetch()
    Visitor.fetch()

  render: =>
    hosts = Host.all()
    @html @view('hosts/index')(hosts: hosts)
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

  edit_rankings: (e) ->
    item = $(e.target).item()
    @navigate '', item.id, 'edit_rankings'

  destroy: (e) ->
    item = $(e.target).item()
    dialog = $('#confirm_delete')
    dialog.dialog('option', 'buttons',
      'Remove Host': ->
        item.destroy()
        $(this).dialog('close')
      'Cancel': ->
        $(this).dialog('close')
    )
    dialog.dialog('open')

  new: ->
    @navigate '/new'
    
class App.Hosts extends Spine.Stack
  controllers:
    index: Index
    edit: Edit
    edit_availabilities: EditAvailabilities
    edit_rankings: EditRankings
    add_rankings: AddRankings
    new: New
    
  routes:
    '/new': 'new'
    '/:id/edit': 'edit'
    '/:id/edit_availabilities': 'edit_availabilities'
    '/:id/edit_rankings': 'edit_rankings'
    '/:id/add_rankings': 'add_rankings'
    '/': 'index'
    
  default: 'index'
  className: 'stack hosts'
