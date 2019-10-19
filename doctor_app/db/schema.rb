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

ActiveRecord::Schema.define(version: 2019_10_18_184741) do

  create_table "institution_address_services", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "institution_address_id"
    t.bigint "service_id"
    t.integer "queue_size"
    t.string "special_mark"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["institution_address_id"], name: "index_institution_address_services_on_institution_address_id"
    t.index ["service_id"], name: "index_institution_address_services_on_service_id"
  end

  create_table "institution_addresses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "institution_id"
    t.bigint "sub_region_id"
    t.string "name"
    t.string "address"
    t.string "contact_info"
    t.float "lat"
    t.float "lon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["institution_id"], name: "index_institution_addresses_on_institution_id"
    t.index ["sub_region_id"], name: "index_institution_addresses_on_sub_region_id"
  end

  create_table "institutions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "regions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "service_categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "service_specialities_mappings", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "service_id"
    t.bigint "speciality_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_id"], name: "index_service_specialities_mappings_on_service_id"
    t.index ["speciality_id"], name: "index_service_specialities_mappings_on_speciality_id"
  end

  create_table "services", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "service_category_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_category_id"], name: "index_services_on_service_category_id"
  end

  create_table "specialist_assignments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "specialist_id"
    t.bigint "speciality_id"
    t.bigint "institution_address_service_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["institution_address_service_id"], name: "index_specialist_assignments_on_institution_address_service_id"
    t.index ["specialist_id"], name: "index_specialist_assignments_on_specialist_id"
    t.index ["speciality_id"], name: "index_specialist_assignments_on_speciality_id"
  end

  create_table "specialists", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "identifier"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "specialities", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sub_regions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "region_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["region_id"], name: "index_sub_regions_on_region_id"
  end

  add_foreign_key "institution_address_services", "institution_addresses"
  add_foreign_key "institution_address_services", "services"
  add_foreign_key "institution_addresses", "institutions"
  add_foreign_key "institution_addresses", "sub_regions"
  add_foreign_key "service_specialities_mappings", "services"
  add_foreign_key "service_specialities_mappings", "specialities"
  add_foreign_key "services", "service_categories"
  add_foreign_key "specialist_assignments", "institution_address_services"
  add_foreign_key "specialist_assignments", "specialists"
  add_foreign_key "specialist_assignments", "specialities"
  add_foreign_key "sub_regions", "regions"
end
