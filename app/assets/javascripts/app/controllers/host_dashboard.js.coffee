$ = jQuery.sub()
TimeSlot = App.TimeSlot
Host = App.Host
HostFieldType = App.HostFieldType
Visitor = App.Visitor

class EditProfile extends Spine.Controller
  events:
    'click [data-type=back]': 'back'
    'submit form': 'submit'

  constructor: ->
    super
    @active () ->
      @change()

  change: () ->
    @item = Host.find(app.role_id)
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
    @active () ->
      @change()

  change: () ->
    @item = Host.find(app.role_id)
    @render()

  render: ->
    @html @view('hosts/edit_availabilities')(host: @item)
    $('#edit_availabilities').fromObject(data: @item.attributes())
    afterRender()

  back: ->
    @navigate '/'

  submit: (e) ->
    e.preventDefault()
    @item.fromForm(e.target)
    if @item.default_room == 'None'
      alert 'Please specify a default meeting location.'
    else
      @item.save()
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
        @change()

  change: (id) ->
    @item = Host.find(app.role_id)
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
    @navigate '/add_rankings', data: @data

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
      @change()

  change: ->
    @item = Host.find(app.role_id)
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
    @navigate '/edit_rankings', data: @data

  submit: () ->
    rankables = $('#add_rankings').toObject().rankables
    if rankables?
      for rankable_id in rankables
        @data.rankings.push(
          rankable_id: rankable_id
        )
      @navigate '/edit_rankings', data: @data

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
    'click [data-type=edit_profile]': 'edit_profile'
    'click [data-type=edit_availabilities]': 'edit_availabilities'
    'click [data-type=edit_rankings]': 'edit_rankings'

  constructor: ->
    super
    showSpinner()
    Host.bind 'refresh change', @render
    TimeSlot.fetch()
    HostFieldType.fetch()
    Visitor.fetch()
    Host.fetch({id: app.role_id})

  render: =>
    @html @view('hosts/dashboard')()
    afterRender()
    hideSpinner()

  edit_profile: () ->
    @navigate '/edit_profile'

  edit_availabilities: () ->
    @navigate '/edit_availabilities'

  edit_rankings: () ->
    @navigate '/edit_rankings'

class App.HostDashboard extends Spine.Stack
  controllers:
    index: Index
    edit_profile: EditProfile
    edit_availabilities: EditAvailabilities
    edit_rankings: EditRankings
    add_rankings: AddRankings

  routes:
    '/edit_profile': 'edit_profile'
    '/edit_availabilities': 'edit_availabilities'
    '/edit_rankings': 'edit_rankings'
    '/add_rankings': 'add_rankings'
    '/': 'index'
    
  default: 'index'
  className: 'stack host_dashboard'
