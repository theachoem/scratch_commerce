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

ActiveRecord::Schema[8.0].define(version: 2024_11_23_163425) do
  create_table "addresses", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "address1"
    t.string "address2"
    t.string "city"
    t.string "postal_code"
    t.string "phone_number"
    t.string "phone_number_intl"
    t.string "alt_phone_number"
    t.string "alt_phone_number_intl"
    t.string "country_code"
    t.integer "province_id"
    t.integer "country_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_addresses_on_country_id"
    t.index ["province_id"], name: "index_addresses_on_province_id"
  end

  create_table "adjustments", force: :cascade do |t|
    t.string "source_type", null: false
    t.integer "source_id", null: false
    t.string "adjustable_type", null: false
    t.integer "adjustable_id", null: false
    t.integer "order_id", null: false
    t.integer "amount", null: false
    t.string "currency", null: false
    t.boolean "included", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["adjustable_type", "adjustable_id"], name: "index_adjustments_on_adjustable"
    t.index ["order_id"], name: "index_adjustments_on_order_id"
    t.index ["source_type", "source_id"], name: "index_adjustments_on_source"
  end

  create_table "assets", force: :cascade do |t|
    t.string "type", limit: 75
    t.string "viewable_type", null: false
    t.integer "viewable_id", null: false
    t.string "alt"
    t.integer "width"
    t.integer "height"
    t.integer "file_size"
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["position"], name: "index_assets_on_position"
    t.index ["viewable_type", "viewable_id"], name: "index_assets_on_viewable"
  end

  create_table "countries", force: :cascade do |t|
    t.string "iso_name", null: false
    t.string "iso", null: false
    t.string "iso3", null: false
    t.string "name", null: false
    t.integer "numcode", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["iso"], name: "index_countries_on_iso"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "inventory_units", force: :cascade do |t|
    t.integer "variant_id", null: false
    t.integer "shipment_id", null: false
    t.integer "line_item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["line_item_id"], name: "index_inventory_units_on_line_item_id"
    t.index ["shipment_id"], name: "index_inventory_units_on_shipment_id"
    t.index ["variant_id"], name: "index_inventory_units_on_variant_id"
  end

  create_table "line_items", force: :cascade do |t|
    t.integer "variant_id", null: false
    t.integer "order_id", null: false
    t.integer "quantity", null: false
    t.decimal "unit_price", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "subtotal", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "adjustment_total", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "total", precision: 10, scale: 2, default: "0.0", null: false
    t.string "currency", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_line_items_on_order_id"
    t.index ["variant_id"], name: "index_line_items_on_variant_id"
  end

  create_table "merchant_users", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "merchant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["merchant_id"], name: "index_merchant_users_on_merchant_id"
    t.index ["user_id"], name: "index_merchant_users_on_user_id"
  end

  create_table "merchants", force: :cascade do |t|
    t.string "name", null: false
    t.integer "status", default: 0, null: false
    t.decimal "commission_rate", default: "0.0", null: false
    t.string "slug", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_merchants_on_deleted_at"
    t.index ["slug"], name: "index_merchants_on_slug", unique: true
  end

  create_table "option_type_products", force: :cascade do |t|
    t.integer "option_type_id", null: false
    t.integer "product_id", null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["option_type_id"], name: "index_option_type_products_on_option_type_id"
    t.index ["position"], name: "index_option_type_products_on_position"
    t.index ["product_id"], name: "index_option_type_products_on_product_id"
  end

  create_table "option_types", force: :cascade do |t|
    t.string "name", limit: 100
    t.string "presentation", limit: 100
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["position"], name: "index_option_types_on_position"
  end

  create_table "option_value_variants", force: :cascade do |t|
    t.integer "option_value_id", null: false
    t.integer "variant_id", null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["option_value_id"], name: "index_option_value_variants_on_option_value_id"
    t.index ["position"], name: "index_option_value_variants_on_position"
    t.index ["variant_id"], name: "index_option_value_variants_on_variant_id"
  end

  create_table "option_values", force: :cascade do |t|
    t.string "name"
    t.string "presentation"
    t.integer "position", default: 0, null: false
    t.integer "option_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["option_type_id"], name: "index_option_values_on_option_type_id"
    t.index ["position"], name: "index_option_values_on_position"
  end

  create_table "orders", force: :cascade do |t|
    t.string "number", limit: 32
    t.string "state", null: false
    t.string "shipment_state"
    t.string "payment_state"
    t.string "email"
    t.integer "user_id"
    t.integer "store_id", null: false
    t.string "currency", null: false
    t.decimal "subtotal", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "adjustment_total", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "total", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "paid_total", precision: 10, scale: 2, default: "0.0", null: false
    t.string "guest_token"
    t.integer "item_count", default: 0, null: false
    t.string "channel", null: false
    t.text "special_instructions"
    t.bigint "approver_id"
    t.datetime "approved_at"
    t.bigint "canceler_id"
    t.datetime "canceled_at"
    t.bigint "billing_address_id"
    t.bigint "shipping_address_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approver_id"], name: "index_orders_on_approver_id"
    t.index ["billing_address_id"], name: "index_orders_on_billing_address_id"
    t.index ["canceler_id"], name: "index_orders_on_canceler_id"
    t.index ["guest_token"], name: "index_orders_on_guest_token", unique: true
    t.index ["number"], name: "index_orders_on_number", unique: true
    t.index ["shipping_address_id"], name: "index_orders_on_shipping_address_id"
    t.index ["store_id"], name: "index_orders_on_store_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "payment_methods", force: :cascade do |t|
    t.string "type", null: false
    t.string "name", null: false
    t.text "description"
    t.boolean "active", default: false
    t.datetime "deleted_at"
    t.json "preferences"
    t.integer "position", default: 0, null: false
    t.integer "visibility", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id", "type"], name: "index_payment_methods_on_id_and_type", unique: true
  end

  create_table "payments", force: :cascade do |t|
    t.string "number", null: false
    t.string "state"
    t.decimal "amount", precision: 10, scale: 2, default: "0.0", null: false
    t.string "currency", null: false
    t.integer "payment_method_id", null: false
    t.integer "order_id", null: false
    t.string "transaction_id"
    t.string "transaction_status"
    t.json "transaction_response"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["number"], name: "index_payments_on_number", unique: true
    t.index ["order_id"], name: "index_payments_on_order_id"
    t.index ["payment_method_id"], name: "index_payments_on_payment_method_id"
  end

  create_table "product_properties", force: :cascade do |t|
    t.string "value"
    t.integer "position", default: 0, null: false
    t.integer "product_id", null: false
    t.integer "property_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["position"], name: "index_product_properties_on_position"
    t.index ["product_id"], name: "index_product_properties_on_product_id"
    t.index ["property_id"], name: "index_product_properties_on_property_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name", null: false
    t.integer "status", default: 0, null: false
    t.text "description"
    t.string "slug", null: false
    t.datetime "available_on"
    t.datetime "discontinued_on"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "merchant_id", null: false
    t.index ["available_on"], name: "index_products_on_available_on"
    t.index ["deleted_at"], name: "index_products_on_deleted_at"
    t.index ["merchant_id"], name: "index_products_on_merchant_id"
    t.index ["slug"], name: "index_products_on_slug", unique: true
  end

  create_table "promotion_actions", force: :cascade do |t|
    t.string "type", null: false
    t.integer "promotion_id", null: false
    t.integer "position", default: 0, null: false
    t.json "preferences"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_promotion_actions_on_deleted_at"
    t.index ["id", "type"], name: "index_promotion_actions_on_id_and_type", unique: true
    t.index ["position"], name: "index_promotion_actions_on_position"
    t.index ["promotion_id"], name: "index_promotion_actions_on_promotion_id"
  end

  create_table "promotion_categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "promotion_rules", force: :cascade do |t|
    t.string "type", null: false
    t.integer "promotion_id", null: false
    t.json "preferences"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id", "type"], name: "index_promotion_rules_on_id_and_type", unique: true
    t.index ["promotion_id"], name: "index_promotion_rules_on_promotion_id"
  end

  create_table "promotions", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.string "code"
    t.boolean "advertise", default: false, null: false
    t.integer "usage_limit", default: 1
    t.datetime "expires_at"
    t.datetime "starts_at"
    t.integer "promotion_category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expires_at"], name: "index_promotions_on_expires_at"
    t.index ["promotion_category_id"], name: "index_promotions_on_promotion_category_id"
    t.index ["starts_at"], name: "index_promotions_on_starts_at"
  end

  create_table "properties", force: :cascade do |t|
    t.string "name", null: false
    t.string "presentation", null: false
    t.integer "attr_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "provinces", force: :cascade do |t|
    t.string "name", null: false
    t.string "abbr", null: false
    t.integer "country_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["abbr", "country_id"], name: "index_provinces_on_abbr_and_country_id", unique: true
    t.index ["country_id"], name: "index_provinces_on_country_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_roles_on_name", unique: true
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "shipments", force: :cascade do |t|
    t.string "state"
    t.string "tracking"
    t.string "number", null: false
    t.decimal "subtotal", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "adjustment_total", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "total", precision: 10, scale: 2, default: "0.0", null: false
    t.string "currency", null: false
    t.integer "order_id", null: false
    t.integer "stock_location_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["number"], name: "index_shipments_on_number", unique: true
    t.index ["order_id"], name: "index_shipments_on_order_id"
    t.index ["stock_location_id"], name: "index_shipments_on_stock_location_id"
  end

  create_table "shipping_categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shipping_method_categories", force: :cascade do |t|
    t.integer "shipping_category_id", null: false
    t.integer "shipping_method_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shipping_category_id"], name: "index_shipping_method_categories_on_shipping_category_id"
    t.index ["shipping_method_id"], name: "index_shipping_method_categories_on_shipping_method_id"
  end

  create_table "shipping_method_zones", force: :cascade do |t|
    t.integer "shipping_method_id", null: false
    t.integer "zone_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shipping_method_id"], name: "index_shipping_method_zones_on_shipping_method_id"
    t.index ["zone_id"], name: "index_shipping_method_zones_on_zone_id"
  end

  create_table "shipping_methods", force: :cascade do |t|
    t.string "name", null: false
    t.string "code"
    t.string "tracking_url"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_shipping_methods_on_code", unique: true
    t.index ["deleted_at"], name: "index_shipping_methods_on_deleted_at"
  end

  create_table "shipping_rate_tax_rates", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, default: "0.0", null: false
    t.integer "tax_rate_id", null: false
    t.integer "shipping_rate_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shipping_rate_id"], name: "index_shipping_rate_tax_rates_on_shipping_rate_id"
    t.index ["tax_rate_id"], name: "index_shipping_rate_tax_rates_on_tax_rate_id"
  end

  create_table "shipping_rates", force: :cascade do |t|
    t.decimal "cost", precision: 10, scale: 2, default: "0.0", null: false
    t.string "currency", null: false
    t.integer "shipping_method_id", null: false
    t.integer "shipment_id", null: false
    t.boolean "selected", default: false, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_shipping_rates_on_deleted_at"
    t.index ["shipment_id"], name: "index_shipping_rates_on_shipment_id"
    t.index ["shipping_method_id"], name: "index_shipping_rates_on_shipping_method_id"
  end

  create_table "stock_items", force: :cascade do |t|
    t.integer "stock_location_id", null: false
    t.integer "variant_id", null: false
    t.integer "inventory_units", default: 0, null: false
    t.integer "printed_units", default: 0, null: false
    t.boolean "backorderable", default: false, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_stock_items_on_deleted_at"
    t.index ["stock_location_id"], name: "index_stock_items_on_stock_location_id"
    t.index ["variant_id"], name: "index_stock_items_on_variant_id"
  end

  create_table "stock_locations", force: :cascade do |t|
    t.string "name", null: false
    t.string "code"
    t.integer "status", default: 0, null: false
    t.string "address1"
    t.string "address2"
    t.string "city"
    t.string "postal_code"
    t.integer "province_id", null: false
    t.integer "country_id", null: false
    t.string "phone_number"
    t.string "phone_number_intl"
    t.string "alt_phone_number"
    t.string "alt_phone_number_intl"
    t.string "country_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_stock_locations_on_code", unique: true
    t.index ["country_id"], name: "index_stock_locations_on_country_id"
    t.index ["province_id"], name: "index_stock_locations_on_province_id"
  end

  create_table "stores", force: :cascade do |t|
    t.string "name", null: false
    t.string "url"
    t.string "default_currency", null: false
    t.boolean "is_default", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["is_default"], name: "index_stores_on_is_default"
  end

  create_table "tax_categories", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.boolean "is_default", default: false, null: false
    t.string "tax_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tax_rate_tax_categories", force: :cascade do |t|
    t.integer "tax_rate_id", null: false
    t.integer "tax_category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tax_category_id"], name: "index_tax_rate_tax_categories_on_tax_category_id"
    t.index ["tax_rate_id"], name: "index_tax_rate_tax_categories_on_tax_rate_id"
  end

  create_table "tax_rates", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.integer "zone_id", null: false
    t.boolean "included", default: false, null: false
    t.string "name", default: "f", null: false
    t.datetime "deleted_at"
    t.datetime "starts_at"
    t.datetime "expires_at"
    t.integer "level", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_tax_rates_on_deleted_at"
    t.index ["zone_id"], name: "index_tax_rates_on_zone_id"
  end

  create_table "taxon_products", force: :cascade do |t|
    t.integer "product_id", null: false
    t.integer "taxon_id", null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["position"], name: "index_taxon_products_on_position"
    t.index ["product_id"], name: "index_taxon_products_on_product_id"
    t.index ["taxon_id"], name: "index_taxon_products_on_taxon_id"
  end

  create_table "taxonomies", force: :cascade do |t|
    t.string "name", null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["position"], name: "index_taxonomies_on_position"
  end

  create_table "taxons", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "permalink", null: false
    t.integer "position", default: 0, null: false
    t.integer "taxonomy_id", null: false
    t.bigint "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_taxons_on_parent_id"
    t.index ["permalink"], name: "index_taxons_on_permalink"
    t.index ["position"], name: "index_taxons_on_position"
    t.index ["taxonomy_id"], name: "index_taxons_on_taxonomy_id"
  end

  create_table "user_roles", force: :cascade do |t|
    t.integer "role_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id", "user_id"], name: "index_user_roles_on_role_id_and_user_id", unique: true
    t.index ["role_id"], name: "index_user_roles_on_role_id"
    t.index ["user_id"], name: "index_user_roles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "variants", force: :cascade do |t|
    t.decimal "markup", default: "0.0", null: false
    t.decimal "cost_price", precision: 8, scale: 2, default: "0.0", null: false
    t.string "currency", null: false
    t.datetime "deleted_at"
    t.integer "product_id", null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_variants_on_deleted_at"
    t.index ["position"], name: "index_variants_on_position"
    t.index ["product_id"], name: "index_variants_on_product_id"
  end

  create_table "zone_members", force: :cascade do |t|
    t.integer "zone_id", null: false
    t.integer "province_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["province_id"], name: "index_zone_members_on_province_id"
    t.index ["zone_id"], name: "index_zone_members_on_zone_id"
  end

  create_table "zones", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "addresses", "countries"
  add_foreign_key "addresses", "provinces"
  add_foreign_key "adjustments", "orders"
  add_foreign_key "inventory_units", "line_items"
  add_foreign_key "inventory_units", "shipments"
  add_foreign_key "inventory_units", "variants"
  add_foreign_key "line_items", "orders"
  add_foreign_key "line_items", "variants"
  add_foreign_key "merchant_users", "merchants"
  add_foreign_key "merchant_users", "users"
  add_foreign_key "option_type_products", "option_types"
  add_foreign_key "option_type_products", "products"
  add_foreign_key "option_value_variants", "option_values"
  add_foreign_key "option_value_variants", "variants"
  add_foreign_key "option_values", "option_types"
  add_foreign_key "orders", "stores"
  add_foreign_key "orders", "users"
  add_foreign_key "payments", "orders"
  add_foreign_key "payments", "payment_methods"
  add_foreign_key "product_properties", "products"
  add_foreign_key "product_properties", "properties"
  add_foreign_key "products", "merchants"
  add_foreign_key "promotion_actions", "promotions"
  add_foreign_key "promotion_rules", "promotions"
  add_foreign_key "promotions", "promotion_categories"
  add_foreign_key "provinces", "countries"
  add_foreign_key "sessions", "users"
  add_foreign_key "shipments", "orders"
  add_foreign_key "shipments", "stock_locations"
  add_foreign_key "shipping_method_categories", "shipping_categories"
  add_foreign_key "shipping_method_categories", "shipping_methods"
  add_foreign_key "shipping_method_zones", "shipping_methods"
  add_foreign_key "shipping_method_zones", "zones"
  add_foreign_key "shipping_rate_tax_rates", "shipping_rates"
  add_foreign_key "shipping_rate_tax_rates", "tax_rates"
  add_foreign_key "shipping_rates", "shipments"
  add_foreign_key "shipping_rates", "shipping_methods"
  add_foreign_key "stock_items", "stock_locations"
  add_foreign_key "stock_items", "variants"
  add_foreign_key "stock_locations", "countries"
  add_foreign_key "stock_locations", "provinces"
  add_foreign_key "tax_rate_tax_categories", "tax_categories"
  add_foreign_key "tax_rate_tax_categories", "tax_rates"
  add_foreign_key "tax_rates", "zones"
  add_foreign_key "taxon_products", "products"
  add_foreign_key "taxon_products", "taxons"
  add_foreign_key "taxons", "taxonomies"
  add_foreign_key "user_roles", "roles"
  add_foreign_key "user_roles", "users"
  add_foreign_key "variants", "products"
  add_foreign_key "zone_members", "provinces"
  add_foreign_key "zone_members", "zones"
end
