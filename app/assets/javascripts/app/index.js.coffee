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

    switch @type
      when 'hosts' then @append(@hosts = new App.Hosts)
    
    Spine.Route.setup()
    window.app = this

window.App = App
