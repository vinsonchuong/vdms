# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101229235652) do

  create_table "admits_meetings", :id => false, :force => true do |t|
    t.integer "admit_id",   :null => false
    t.integer "meeting_id", :null => false
  end

  add_index "admits_meetings", ["admit_id", "meeting_id"], :name => "index_admits_meetings_on_admit_id_and_meeting_id", :unique => true

  create_table "meetings", :force => true do |t|
    t.time     "time"
    t.string   "room"
    t.integer  "faculty_id"
    t.integer  "max_admits_per_meeting"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", :force => true do |t|
    t.string   "calnet_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "type"
    t.string   "area"
    t.string   "division"
    t.string   "schedule"
    t.string   "default_room"
    t.integer  "max_students_per_meeting"
    t.integer  "max_additional_students"
    t.string   "phone"
    t.string   "area1"
    t.string   "area2"
    t.boolean  "attending"
    t.string   "available_times"
    t.integer  "peer_advisor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rankings", :force => true do |t|
    t.integer  "rank"
    t.string   "type"
    t.integer  "faculty_id"
    t.integer  "admit_id"
    t.boolean  "mandatory"
    t.integer  "time_slots"
    t.boolean  "one_on_one"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "settings", :force => true do |t|
    t.string   "var",                       :null => false
    t.text     "value"
    t.integer  "target_id"
    t.string   "target_type", :limit => 30
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["target_type", "target_id", "var"], :name => "index_settings_on_target_type_and_target_id_and_var", :unique => true

end
