$ = jQuery.sub()
Meeting = App.Meeting
Host = App.Host
HostFieldType = App.HostFieldType
Visitor = App.Visitor
VisitorFieldType = App.VisitorFieldType
TimeSlot = App.TimeSlot

$.fn.item = ->
  elementID   = $(@).data('id')
  elementID or= $(@).parents('[data-id]').data('id')
  Meeting.find(elementID)

class Index extends Spine.Controller
  events:
    'click [data-type=generate]': 'generate'
    'click [data-type=view]': 'toggle_fields'

  constructor: ->
    super
    Meeting.bind 'refresh change', @render
    Host.fetch()
    HostFieldType.fetch()
    Visitor.fetch()
    VisitorFieldType.fetch()
    TimeSlot.fetch()
    Meeting.fetch()

  render: =>
    meetings = Meeting.all()
    @html @view('meetings/index')(
      meetings: meetings,
      helper:
        render_host_field: (field) =>
          host_field_type = HostFieldType.find(field.field_type_id)
          @view("data_type_show/#{host_field_type.data_type}")(name: host_field_type.name, data: field.data)
        render_visitor_field: (field) =>
          visitor_field_type = VisitorFieldType.find(field.field_type_id)
          @view("data_type_show/#{visitor_field_type.data_type}")(name: visitor_field_type.name, data: field.data)
    )
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
        Meeting.refresh([], clear: true)
        showSpinner()
        $.post('/events/1/meetings/generate', ->
          Meeting.fetch()
          hideSpinner()
        )
      'Cancel': ->
        $(this).dialog('close')
    )
    dialog.dialog('open')

  toggle_fields: (e) ->
    item = $(e.target).item()
    $('dl', "tr[data-id=#{item.id}]").toggle()

class App.Meetings extends Spine.Stack
  controllers:
    index: Index

  routes:
    '/': 'index'
    
  default: 'index'
  className: 'stack hosts'
