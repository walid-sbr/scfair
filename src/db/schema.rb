# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_06_22_141020) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "datasets", force: :cascade do |t|
    t.string "collection_id"
    t.string "dataset_id"
    t.string "source"
    t.string "doi"
    t.string "cell_types", default: [], array: true
    t.string "tissue", default: [], array: true
    t.string "tissue_uberon", default: [], array: true
    t.string "developmental_stage", default: [], array: true
    t.string "developmental_stage_id", default: [], array: true
    t.string "sex", default: [], array: true
    t.string "organisms", default: [], array: true
    t.string "disease", default: [], array: true
    t.string "assay_info", default: [], array: true
    t.integer "number_of_cells", default: [], array: true
    t.string "processed_data", default: [], array: true
    t.string "link_to_dataset"
    t.string "link_to_explore_data", default: [], array: true
    t.string "link_to_raw_data", default: [], array: true
    t.string "dataset_hash"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "journals", force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ontology_terms", force: :cascade do |t|
    t.string "identifier"
    t.string "name"
    t.string "parents"
    t.string "children"
    t.string "all_children"
    t.string "all_parents"
    t.string "exists_in_datasets"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identifier"], name: "index_ontology_terms_on_identifier", unique: true
  end

  create_table "studies", force: :cascade do |t|
    t.text "title"
    t.text "first_author"
    t.text "authors"
    t.text "authors_json"
    t.text "abstract"
    t.bigint "journal_id"
    t.text "volume"
    t.text "issue"
    t.text "doi"
    t.integer "year"
    t.text "comment"
    t.text "description"
    t.datetime "published_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["doi"], name: "index_studies_on_doi", unique: true
    t.index ["journal_id"], name: "index_studies_on_journal_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "studies", "journals"
end
