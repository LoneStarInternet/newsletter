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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20150507195612) do

  create_table "news_areas", :force => true do |t|
    t.string   "name",        :null => false
    t.string   "description"
    t.integer  "design_id"
    t.integer  "updated_by"
    t.datetime "deleted_at"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "news_areas_news_elements", :id => false, :force => true do |t|
    t.integer "area_id",    :null => false
    t.integer "element_id", :null => false
  end

  create_table "news_assets", :force => true do |t|
    t.integer  "field_id"
    t.integer  "piece_id"
    t.string   "image"
    t.string   "content_type"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
    t.integer  "parent_id"
    t.string   "thumbnail"
    t.integer  "updated_by"
    t.datetime "deleted_at"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "news_designs", :force => true do |t|
    t.string   "name",            :null => false
    t.string   "description"
    t.text     "html_design"
    t.integer  "updated_by"
    t.datetime "deleted_at"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.text     "stylesheet_text"
  end

  create_table "news_elements", :force => true do |t|
    t.string   "name",        :null => false
    t.string   "description"
    t.text     "html_design"
    t.integer  "design_id"
    t.integer  "updated_by"
    t.datetime "deleted_at"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "news_field_values", :force => true do |t|
    t.integer  "piece_id",   :null => false
    t.integer  "field_id",   :null => false
    t.string   "key",        :null => false
    t.text     "value",      :null => false
    t.integer  "updated_by"
    t.datetime "deleted_at"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "news_fields", :force => true do |t|
    t.string   "name",        :null => false
    t.integer  "element_id",  :null => false
    t.string   "label"
    t.integer  "sequence"
    t.boolean  "is_required"
    t.string   "description"
    t.string   "type"
    t.integer  "updated_by"
    t.datetime "deleted_at"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "news_newsletters", :force => true do |t|
    t.string   "name",         :null => false
    t.string   "description"
    t.integer  "design_id"
    t.integer  "sequence"
    t.datetime "published_at"
    t.integer  "updated_by"
    t.datetime "deleted_at"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "news_pieces", :force => true do |t|
    t.integer  "newsletter_id", :null => false
    t.integer  "area_id",       :null => false
    t.integer  "element_id",    :null => false
    t.integer  "sequence",      :null => false
    t.integer  "updated_by"
    t.datetime "deleted_at"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
