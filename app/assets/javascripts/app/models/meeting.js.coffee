class App.Meeting extends Spine.Model
  @configure 'Meeting', 'host_id', 'visitor_id', 'time_slot_id', 'score'
  @extend Spine.Model.Ajax
