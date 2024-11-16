bin/rails db:drop
bin/rails db:create

rm db/schema.rb

# bin/rails g model OptionType name:string{100} presentation:string{100} position:integer:index --force
# bin/rails g model OptionValue name:string{100} presentation:string{100} position:integer:index option_type:references:index --force
# bin/rails g model Asset viewable:references{polymorphic} alt:string width:integer height:integer file_size:integer position:integer:index --force

# bin/rails g model Product \
#   name:string \
#   status:integer \
#   description:text \
#   slug:string:uniq:index \
#   available_on:datetime:index \
#   discontinued_on:datetime \
#   deleted_at:datetime:index \
#   --force

# bin/rails g model Variant \
#   option_texts:string \
#   markup:decimal \
#   cost_price:decimal \
#   currency:string \
#   deleted_at:datetime:index \
#   product:references \
#   position:integer:index \
#   --force

# bin/rails g model OptionValueVariant \
#   option_value:references \
#   variant:references:index \
#   position:integer:index \
#   --force

# bin/rails g model OptionTypeProduct \
#   option_type:references \
#   product:references:index \
#   position:integer:index \
#   --force

# bin/rails g model Taxonomy \
#   name:string \
#   position:integer:index \
#   --force

# bin/rails g model Taxon \
#   name:string \
#   description:text \
#   permalink:string \
#   position:integer:index \
#   taxonomy:references:index \
#   parent_id:integer:index \
#   --force

# bin/rails g model TaxonProduct \
#   product:references:index \
#   taxon:references:index \
#   position:integer:index \
#   --force

# bin/rails g model Country \
#   iso_name:string \
#   iso:string:index \
#   iso3:string \
#   name:string \
#   numcode:integer \
#   --force

# bin/rails g model Province \
#   name:string \
#   abbr:string \
#   country:references \
#   --force

# bin/rails g model Zone \
#   name:text \
#   description:text \
#   --force

# bin/rails g model ZoneMember \
#   zone:references \
#   province:references \
#   --force

# bin/rails g model Address \
#   first_name:string \
#   last_name:string \
#   address1:string \
#   address2:string \
#   city:string \
#   postal_code:string \
#   phone_number:string \
#   alt_phone_number:string \
#   province:references:index \
#   country:references:index \
#   --force

# bin/rails g model Property \
#   name:string \
#   presentation:string \
#   attr_type:integer \
#   --force

# bin/rails g model ProductProperty \
#   product:references \
#   property:references \
#   value:string \
#   --force

# bin/rails g model Role name:string:index --force
# bin/rails g model UserRole role:references user:references --force

# bin/rails g model Stores \
#   name:string \
#   url:string \
#   default_currency:string \
#   is_default:boolean \
#   --force

# bin/rails g model Order \
#   number:string:index \
#   state:string \
#   shipment_state:string \
#   payment_state:string \
#   email:string \
#   user:references \
#   store:references \
#   currency:string \
#   subtotal:decimal \
#   adjustment_total:decimal \
#   total:decimal \
#   paid_total:decimal \
#   guest_token:string \
#   item_count:integer \
#   channel:string \
#   special_instructions:text \
#   approver_id:integer:index \
#   approved_at:datetime \
#   canceler_id:integer:index \
#   canceled_at:datetime \
#   billing_address_id:integer:index \
#   shipping_address_id:integer:index \
#   --force

# bin/rails g model LineItem \
#   variant:references \
#   order:references \
#   quantity:integer \
#   unit_price:decimal \
#   subtotal:decimal \
#   adjustment_total:decimal \
#   total:decimal \
#   currency:string \
#   --force

# bin/rails g model Adjustment \
#   source:references{polymorphic} \
#   adjustable:references{polymorphic} \
#   order:references \
#   amount:integer \
#   currency:string \
#   included:boolean \
#   --force

# bin/rails g model Adjustment \
#   source:references{polymorphic} \
#   adjustable:references{polymorphic} \
#   order:references \
#   amount:integer \
#   currency:string \
#   included:boolean \
#   --force

# bin/rails g model TaxCategory \
#   name:string \
#   description:string \
#   is_default:boolean \
#   tax_code:string \
#   --force

# bin/rails g model TaxRate \
#   amount:decimal \
#   zone:references \
#   included:boolean \
#   name:string \
#   deleted_at:datetime:index \
#   starts_at:datetime \
#   expires_at:datetime \
#   level:boolean \
#   --force

# bin/rails g model TaxRateTaxCategory \
#   tax_rate:references \
#   tax_category:references \
#   --force

# bin/rails g model StockLocation \
#   name:string \
#   code:string:uniq \
#   status:integer \
#   address1:string \
#   address2:string \
#   city:string \
#   postal_code:string \
#   province:references:index \
#   country:references:index \
#   phone_number:string \
#   alt_phone_number:string \
#   --force

# bin/rails g model StockItem \
#   stock_location:references \
#   variant:references \
#   inventory_units:integer \
#   printed_units:integer \
#   backorderable:boolean \
#   deleted_at:datetime:index \
#   --force

# bin/rails g model ShippingCategory \
#   name:string \
#   --force

# bin/rails g model ShippingMethod \
#   name:string \
#   code:string:uniq \
#   tracking_url:string \
#   deleted_at:datetime:index \
#   --force

# bin/rails g model ShippingMethodCategory \
#   shipping_category:references \
#   shipping_method:references \
#   --force

# bin/rails g model Shipment \
#   state:string \
#   tracking:string \
#   number:string \
#   subtotal:decimal \
#   adjustment_total:decimal \
#   total:decimal \
#   currency:string \
#   order:references \
#   stock_location:references \
#   --force

# bin/rails g model ShippingRate \
#   cost:decimal \
#   shipping_method:references \
#   shipment:references \
#   selected:boolean \
#   deleted_at:datetime:index \
#   --force

# bin/rails g model ShippingRateTaxRate \
#   amount:decimal \
#   tax_rate:references \
#   shipping_rate:references \
#   --force

# bin/rails g model InventoryUnit \
#   variant:references \
#   shipment:references \
#   line_item:references \
#   --force

# bin/rails g model ShippingMethodZone \
#   shipping_method:references \
#   zone:references \
#   --force

# bin/rails g model PaymentMethod \
#   type:string \
#   name:string \
#   description:text \
#   active:boolean \
#   deleted_at:datetime \
#   preferences:json \
#   position:integer \
#   visibility:integer \
#   --force

# bin/rails g model Payment \
#   number:string \
#   state:string \
#   amount:decimal \
#   currency:string \
#   payment_method:references \
#   order:references \
#   transaction_id:string \
#   transaction_status:string \
#   transaction_response:json \
#   --force

# bin/rails g model PromotionCategory \
#   name:string \
#   --force

# bin/rails g model Promotion \
#   name:string \
#   description:string \
#   code:string \
#   advertise:boolean \
#   usage_limit:integer \
#   expires_at:datetime:index \
#   starts_at:datetime:index \
#   promotion_category:references \
#   --force

# bin/rails g model PromotionRule \
#   type:string \
#   promotion:references \
#   preferences:json \
#   --force

# bin/rails g model PromotionAction \
#   type:string \
#   promotion:references \
#   position:integer:index \
#   preferences:json \
#   deleted_at:datetime:index \
#   --force

bin/rails db:migrate
bin/rails db:seed

# Make sure these database is migrate with unique, decimal
# Make connection between models