$ = jQuery.sub()
Meeting = App.Meeting
Host = App.Host
Visitor = App.Visitor
TimeSlot = App.TimeSlot

$.fn.item = ->
  elementID   = $(@).data('id')
  elementID or= $(@).parents('[data-id]').data('id')
  Host.find(elementID)

class Index extends Spine.Controller
  events:
    'click [data-type=generate]': 'generate'

  constructor: ->
    super
    Meeting.bind 'refresh change', @render
    Host.fetch()
    Visitor.fetch()
    TimeSlot.fetch()
    Meeting.fetch()

  render: =>
    meetings = Meeting.all()
    @html @view('meetings/index')(meetings: meetings)
    $('#confirm_generate').dialog(
      autoOpen: false
      modal: true
      resizable: false
    )
    afterRender()

  generate: (e) ->
    dialog = $('#confirm_generate')
    dialog.dialog('option', 'buttons',
      'Generate': ->
        $(this).dialog('close')
        showSpinner()
        $.post('/events/1/meetings/generate', ->
          Meeting.fetch()
          hideSpinner()
        )
      'Cancel': ->
        $(this).dialog('close')
    )
    dialog.dialog('open')

class App.Meetings extends Spine.Stack
  controllers:
    index: Index

  routes:
    '/': 'index'
    
  default: 'index'
  className: 'stack hosts'
