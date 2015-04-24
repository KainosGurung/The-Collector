# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141106220402) do

  create_table "behaviors", force: true do |t|
    t.string  "behavior_name"
    t.string  "behavior_description"
    t.boolean "active"
  end

  create_table "incidents", force: true do |t|
    t.integer  "provider_id"
    t.integer  "patient_id"
    t.integer  "behavior_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "patientbehaviors", force: true do |t|
    t.integer "patient_id"
    t.integer "behavior_id"
  end

  create_table "patientproviders", force: true do |t|
    t.integer "provider_id"
    t.integer "patient_id"
  end

  create_table "patients", force: true do |t|
    t.string  "patient_name"
    t.boolean "active"
  end

  create_table "providers", force: true do |t|
    t.string  "provider_name"
    t.string  "password_salt"
    t.string  "password_hash"
    t.integer "admin"
    t.boolean "active"
  end

end
