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
    @active @render

  render: ->
    @item = Host.find(app.role_id)
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
    @active @render

  render: ->
    @item = Host.find(app.role_id)
    @html @view('hosts/edit_availabilities')(host: @item)
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
    'click [data-type=edit_profile]': 'edit_profile'
    'click [data-type=edit_availabilities]': 'edit_availabilities'

  constructor: ->
    super
    Host.bind 'refresh change', @render
    TimeSlot.fetch()
    Host.fetch({id: app.role_id})
    HostFieldType.fetch()
    Visitor.fetch()

  render: =>
    @html @view('hosts/dashboard')()
    afterRender()

  edit_profile: () ->
    @navigate '/edit_profile'

  edit_availabilities: () ->
    @navigate '/edit_availabilities'

class App.HostDashboard extends Spine.Stack
  controllers:
    index: Index
    edit_profile: EditProfile
    edit_availabilities: EditAvailabilities

  routes:
    '/edit_profile': 'edit_profile'
    '/edit_availabilities': 'edit_availabilities'
    '/': 'index'
    
  default: 'index'
  className: 'stack host_dashboard'