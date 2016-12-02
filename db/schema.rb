ActiveRecord::Schema.define(version: 20161202023131) do

  enable_extension "plpgsql"

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "picture"
    t.boolean  "owner"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end
