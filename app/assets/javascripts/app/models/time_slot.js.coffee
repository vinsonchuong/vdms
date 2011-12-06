class App.TimeSlot extends Spine.Model
  @configure 'TimeSlot', 'begin', 'end'
  @extend Spine.Model.Ajax
  @url = ->
    Spine.Model.host + '/time_slots'
