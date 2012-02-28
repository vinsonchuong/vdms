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
    @item = Visitor.find(id)
    @data = @item.attributes()
    @render()

  render: ->
    @html @view('visitors/edit_rankings')(visitor: @data)
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
    Visitor.fetch({id: @item.id})
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
    @item = Visitor.find(id)
    @ranked = {}
    if not @data.rankings?
      @data.rankings = []
    for ranking in @data.rankings
      @ranked[ranking.rankable_id] = true
    @rankables = Host.select((v) => not @ranked[v.id])
    @areas = VisitorFieldType.first().options.selection_items
    @render()

  render: ->
    @html @view('visitors/add_rankings')(visitors: @data, rankables: @rankables, areas: @areas)
    $('#add_rankings tbody').html(@view('visitors/rankables')(rankables: @rankables))
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
      @rankables = Host.select((v) =>
          not @ranked[v.id] and v.fields[0].data? and areas_lookup[v.fields[0].data.answer]
      )
    else
      @rankables = Host.select((v) => not @ranked[v.id])
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

  edit_rankings: (e) ->
    item = $(e.target).item()
    @navigate '', item.id, 'edit_rankings'

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
  className: 'stack visitors'
