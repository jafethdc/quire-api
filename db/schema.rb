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

ActiveRecord::Schema.define(version: 20161217192147) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "product_images", force: :cascade do |t|
    t.integer  "product_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "img_file_name"
    t.string   "img_content_type"
    t.integer  "img_file_size"
    t.datetime "img_updated_at"
    t.index ["product_id"], name: "index_product_images_on_product_id", using: :btree
  end

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.decimal  "price",       precision: 8, scale: 2
    t.integer  "seller_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["seller_id"], name: "index_products_on_seller_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string    "username",                                                                     null: false
    t.string    "email",                                                                        null: false
    t.string    "full_name",                                                                    null: false
    t.geography "last_known_location", limit: {:srid=>4326, :type=>"point", :geographic=>true}
    t.string    "access_token"
    t.datetime  "created_at",                                                                   null: false
    t.datetime  "updated_at",                                                                   null: false
    t.integer   "preference_radius"
    t.index ["username"], name: "index_users_on_username", unique: true, using: :btree
  end

end
