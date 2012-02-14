#= require json2
#= require jquery
#= require spine
#= require spine/manager
#= require spine/ajax
#= require spine/route

#= require_tree ./lib
#= require_self
#= require_tree ./models
#= require_tree ./controllers
#= require_tree ./views

class App extends Spine.Controller
  constructor: ->
    super

    Spine.Model.host = '/events/' + @event_id

    if @auth_token? and @auth_token != ''
      $.ajaxSetup
        data: 'auth_token=' + @auth_token
        headers:
          auth_token: @auth_token

    @navigate '/'

    switch @type
      when 'hosts' then @append(@hosts = new App.Hosts)
      when 'host_dashboard' then @append(@host_dashboard = new App.HostDashboard)
      when 'visitors' then @append(@visitors = new App.Visitors)
      when 'visitor_dashboard' then @append(@visitor_dashboard = new App.VisitorDashboard)
      when 'host_field_types' then @append(@host_field_types = new App.HostFieldTypes)
      when 'visitor_field_types' then @append(@visitor_field_types = new App.VisitorFieldTypes)
      when 'goals' then @append(@goals = new App.Goals)
      when 'constraints' then @append(@constraints = new App.Constraints)
      when 'meetings' then @append(@goals = new App.Meetings)

    Spine.Route.setup()
    window.app = this

window.App = App
