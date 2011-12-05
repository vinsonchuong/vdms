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

    @navigate '/'

    switch @type
      when 'hosts' then @append(@hosts = new App.Hosts)
      when 'host_field_types' then @append(@host_field_types = new App.HostFieldTypes)

    Spine.Route.setup()
    window.app = this

window.App = App
