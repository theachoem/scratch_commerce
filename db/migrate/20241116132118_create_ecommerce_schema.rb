class CreateEcommerceSchema < ActiveRecord::Migration[8.0]
  def change
    create_table :option_types do |t|
      t.string :name, limit: 100
      t.string :presentation, limit: 100
      t.integer :position, default: 0, null: false, index: true

      t.timestamps
    end

    create_table :option_values do |t|
      t.string :name
      t.string :presentation
      t.integer :position, default: 0, null: false, index: true
      t.references :option_type, null: false, foreign_key: true

      t.timestamps
    end

    create_table :assets do |t|
      t.string :type, limit: 75
      t.references :viewable, polymorphic: true, null: false
      t.string :alt
      t.integer :width
      t.integer :height
      t.integer :file_size
      t.integer :position, default: 0, null: false, index: true

      t.timestamps
    end

    create_table :products do |t|
      t.string :name, null: false
      t.integer :status, default: 0, null: false
      t.text :description
      t.string :slug, null: false, index: { unique: true }
      t.datetime :available_on, index: true
      t.datetime :discontinued_on
      t.datetime :deleted_at, index: true

      t.timestamps
    end

    create_table :variants do |t|
      t.decimal :markup, default: 0, null: false
      t.decimal :cost_price, precision: 8, scale: 2, default: 0, null: false
      t.string :currency, null: false
      t.datetime :deleted_at, index: true
      t.references :product, null: false, foreign_key: true
      t.integer :position, default: 0, null: false, index: true

      t.timestamps
    end

    create_table :option_value_variants do |t|
      t.references :option_value, null: false, foreign_key: true
      t.references :variant, null: false, foreign_key: true
      t.integer :position, default: 0, null: false, index: true

      t.timestamps
    end

    create_table :option_type_products do |t|
      t.references :option_type, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :position, default: 0, null: false, index: true

      t.timestamps
    end

    create_table :taxonomies do |t|
      t.string :name, null: false
      t.integer :position, default: 0, null: false, index: true

      t.timestamps
    end

    create_table :taxons do |t|
      t.string :name, null: false
      t.text :description
      t.string :permalink, null: false, index: true
      t.integer :position, default: 0, null: false, index: true
      t.references :taxonomy, null: false, foreign_key: true
      t.bigint :parent_id, index: true

      t.timestamps
    end

    create_table :taxon_products do |t|
      t.references :product, null: false, foreign_key: true
      t.references :taxon, null: false, foreign_key: true
      t.integer :position, default: 0, null: false, index: true

      t.timestamps
    end

    create_table :countries do |t|
      t.string :iso_name, null: false
      t.string :iso, null: false, index: true
      t.string :iso3, null: false
      t.string :name, null: false
      t.integer :numcode, null: false

      t.timestamps
    end

    create_table :provinces do |t|
      t.string :name, null: false
      t.string :abbr, null: false
      t.references :country, null: false, foreign_key: true

      t.timestamps
      t.index [ :abbr, :country_id ], unique: true
    end

    create_table :zones do |t|
      t.string :name, null: false
      t.text :description

      t.timestamps
    end

    create_table :zone_members do |t|
      t.references :zone, null: false, foreign_key: true
      t.references :province, null: false, foreign_key: true

      t.timestamps
    end

    create_table :addresses do |t|
      t.string :first_name
      t.string :last_name
      t.string :address1
      t.string :address2
      t.string :city
      t.string :postal_code

      t.string :phone_number
      t.string :phone_number_intl

      t.string :alt_phone_number
      t.string :alt_phone_number_intl

      t.string :country_code

      t.references :province, null: false, foreign_key: true
      t.references :country, null: false, foreign_key: true

      t.timestamps
    end

    create_table :properties do |t|
      t.string :name, null: false
      t.string :presentation, null: false
      t.integer :attr_type, null: false

      t.timestamps
    end

    create_table :product_properties do |t|
      t.string :value
      t.integer :position, default: 0, null: false, index: true

      t.references :product, null: false, foreign_key: true
      t.references :property, null: false, foreign_key: true

      t.timestamps
    end

    create_table :roles do |t|
      t.string :name, index: { unique: true }

      t.timestamps
    end

    create_table :user_roles do |t|
      t.references :role, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
      t.index [ :role_id, :user_id ], unique: true
    end

    create_table :stores do |t|
      t.string :name
      t.string :url
      t.string :default_currency
      t.boolean :is_default, index: true

      t.timestamps
    end

    create_table :orders do |t|
      t.string :number, limit: 32, index: { unique: true }
      t.string :state, null: false
      t.string :shipment_state
      t.string :payment_state
      t.string :email

      t.references :user, null: false, foreign_key: true
      t.references :store, null: false, foreign_key: true

      t.string :currency, null: false
      t.decimal :subtotal, precision: 10, scale: 2, default: 0.0, null: false
      t.decimal :adjustment_total, precision: 10, scale: 2, default: 0.0, null: false
      t.decimal :total, precision: 10, scale: 2, default: 0.0, null: false
      t.decimal :paid_total, precision: 10, scale: 2, default: 0.0, null: false

      t.string :guest_token, index: { unique: true }
      t.integer :item_count, default: 0, null: false

      t.string :channel, null: false
      t.text :special_instructions

      t.bigint :approver_id, index: true
      t.datetime :approved_at

      t.bigint :canceler_id, index: true
      t.datetime :canceled_at

      t.bigint :billing_address_id, index: true
      t.bigint :shipping_address_id, index: true

      t.timestamps
    end

    create_table :line_items do |t|
      t.references :variant, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true
      t.integer :quantity, null: false

      t.decimal :unit_price, precision: 10, scale: 2, default: 0.0, null: false
      t.decimal :subtotal, precision: 10, scale: 2, default: 0.0, null: false
      t.decimal :adjustment_total, precision: 10, scale: 2, default: 0.0, null: false
      t.decimal :total, precision: 10, scale: 2, default: 0.0, null: false

      t.string :currency, null: false

      t.timestamps
    end

    create_table :adjustments do |t|
      t.references :source, polymorphic: true, null: false
      t.references :adjustable, polymorphic: true, null: false
      t.references :order, null: false, foreign_key: true

      t.integer :amount, precision: 10, scale: 2, null: false
      t.string :currency, null: false
      t.boolean :included, default: false, null: false

      t.timestamps
    end

    create_table :tax_categories do |t|
      t.string :name, null: false
      t.string :description
      t.boolean :is_default, default: false, null: false
      t.string :tax_code

      t.timestamps
    end

    create_table :tax_rates do |t|
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.references :zone, null: false, foreign_key: true
      t.boolean :included, default: false, null: false
      t.string :name, default: false, null: false
      t.datetime :deleted_at
      t.datetime :starts_at
      t.datetime :expires_at

      t.integer :level, default: 0, null: false

      t.timestamps
    end
    add_index :tax_rates, :deleted_at

    create_table :tax_rate_tax_categories do |t|
      t.references :tax_rate, null: false, foreign_key: true
      t.references :tax_category, null: false, foreign_key: true

      t.timestamps
    end

    create_table :stock_locations do |t|
      t.string :name, null: false
      t.string :code
      t.integer :status, default: 0, null: false
      t.string :address1
      t.string :address2
      t.string :city
      t.string :postal_code

      t.references :province, null: false, foreign_key: true
      t.references :country, null: false, foreign_key: true

      t.string :phone_number
      t.string :phone_number_intl

      t.string :alt_phone_number
      t.string :alt_phone_number_intl

      t.string :country_code

      t.timestamps
    end
    add_index :stock_locations, :code, unique: true

    create_table :stock_items do |t|
      t.references :stock_location, null: false, foreign_key: true
      t.references :variant, null: false, foreign_key: true
      t.integer :inventory_units, default: 0, null: false
      t.integer :printed_units, default: 0, null: false
      t.boolean :backorderable, default: false, null: false
      t.datetime :deleted_at, index: true

      t.timestamps
    end

    create_table :shipping_categories do |t|
      t.string :name, null: false

      t.timestamps
    end

    create_table :shipping_methods do |t|
      t.string :name, null: false
      t.string :code, index: { unique: true }
      t.string :tracking_url
      t.datetime :deleted_at, index: true

      t.timestamps
    end

    create_table :shipping_method_categories do |t|
      t.references :shipping_category, null: false, foreign_key: true
      t.references :shipping_method, null: false, foreign_key: true

      t.timestamps
    end

    create_table :shipments do |t|
      t.string :state
      t.string :tracking
      t.string :number, null: false, index: { unique: true }

      t.decimal :subtotal, precision: 10, scale: 2, default: 0.0, null: false
      t.decimal :adjustment_total, precision: 10, scale: 2, default: 0.0, null: false
      t.decimal :total, precision: 10, scale: 2, default: 0.0, null: false

      t.string :currency, null: false

      t.references :order, null: false, foreign_key: true
      t.references :stock_location, null: false, foreign_key: true

      t.timestamps
    end

    create_table :shipping_rates do |t|
      t.decimal :cost, precision: 10, scale: 2, default: 0.0, null: false
      t.string :currency, null: false

      t.references :shipping_method, null: false, foreign_key: true
      t.references :shipment, null: false, foreign_key: true

      t.boolean :selected, default: false, null: false
      t.datetime :deleted_at, index: true

      t.timestamps
    end

    create_table :shipping_rate_tax_rates do |t|
      t.decimal :amount, precision: 10, scale: 2, default: 0.0, null: false
      t.references :tax_rate, null: false, foreign_key: true
      t.references :shipping_rate, null: false, foreign_key: true

      t.timestamps
    end

    create_table :inventory_units do |t|
      t.references :variant, null: false, foreign_key: true
      t.references :shipment, null: false, foreign_key: true
      t.references :line_item, null: false, foreign_key: true

      t.timestamps
    end

    create_table :shipping_method_zones do |t|
      t.references :shipping_method, null: false, foreign_key: true
      t.references :zone, null: false, foreign_key: true

      t.timestamps
    end

    create_table :payment_methods do |t|
      t.string :type, null: false
      t.string :name, null: false
      t.text :description
      t.boolean :active, default: false
      t.datetime :deleted_at

      t.json :preferences
      t.integer :position, default: 0, null: false
      t.integer :visibility, default: 0, null: false

      t.timestamps
      t.index [ :id, :type ], unique: true
    end

    create_table :payments do |t|
      t.string :number, null: false, index: { unique: true }
      t.string :state

      t.decimal :amount, precision: 10, scale: 2, default: 0.0, null: false
      t.string :currency, null: false

      t.references :payment_method, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true

      t.string :transaction_id
      t.string :transaction_status
      t.json :transaction_response

      t.timestamps
    end

    create_table :promotion_categories do |t|
      t.string :name, null: false

      t.timestamps
    end

    create_table :promotions do |t|
      t.string :name, null: false
      t.string :description
      t.string :code
      t.boolean :advertise, default: false, null: false
      t.integer :usage_limit, default: 1
      t.datetime :expires_at, index: true
      t.datetime :starts_at, index: true
      t.references :promotion_category, null: false, foreign_key: true

      t.timestamps
    end

    create_table :promotion_rules do |t|
      t.string :type, null: false
      t.references :promotion, null: false, foreign_key: true
      t.json :preferences

      t.timestamps
      t.index [ :id, :type ], unique: true
    end

    create_table :promotion_actions do |t|
      t.string :type, null: false
      t.references :promotion, null: false, foreign_key: true
      t.integer :position, default: 0, null: false, index: true
      t.json :preferences
      t.datetime :deleted_at, index: true

      t.timestamps
      t.index [ :id, :type ], unique: true
    end
  end
end
