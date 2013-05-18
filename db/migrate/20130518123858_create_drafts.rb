class CreateDrafts < ActiveRecord::Migration
  def change
    create_table :drafts do |t|
    t.string   "name"
    t.string   "state"
    t.text     "description"
    t.integer  "user_id"
    t.string   "city"
    t.string   "zip"
    t.string   "subdivision"
    t.float    "price"
    t.integer  "square_footage"
    t.integer  "bed_rooms"
    t.integer  "bath_rooms"
    t.integer  "product_id"
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "gmaps"
    t.string   "slug"
    t.text     "address"
    t.integer  "status"
    t.integer  "selected_package_id"
    t.datetime "deleted_at"
    t.string   "address1"
    t.string   "address2"
    t.timestamps
    end
  end
end
