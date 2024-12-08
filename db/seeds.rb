# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or create!d alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create!_by!(name: genre_name)
#   end

admin_role = Role.create!(name: 'admin')
merchant_role = Role.create!(name: 'merchant')

User.create!(email: "admin@gmail.com", password: "12345678", roles: [ admin_role ])
merchant_user = User.create!(email: "merchant@gmail.com", password: "12345678", roles: [ merchant_role ])
Store.create(name: "Sahakom.com", is_default: true, default_currency: 'KHR')

size_option_type = OptionType.create!(name: "size", presentation: "Size")
red_option_value = size_option_type.option_values.create!(name: "red", presentation: "Red")
blue_option_value = size_option_type.option_values.create!(name: "blue", presentation: "Blue")
black_option_value = size_option_type.option_values.create!(name: "black", presentation: "Black")

country = Country.create!(name: "Cambodia", numcode: "116", iso: "KH", iso3: "KHM", iso_name: "CAMBODIA")
province = country.provinces.create!(name: "Phnom Penh", abbr: "PP")
stock_location = province.stock_locations.create!(name: "MyMerchant Warehouse", status: :active)
merchant = Merchant.create!(name: "MyMerchant", status: :active, commission_rate: 0, users: [ merchant_user ])
product = Product.create!(name: "TShirt", merchant: merchant, status: :active, option_types: [ size_option_type ])

image_file = Rails.root.join('public/icon.png')
product.images.attach(io: File.open(image_file), filename: File.basename(image_file))

variant_a = product.variants.create!(option_values: [ red_option_value ])
variant_b = product.variants.create!(option_values: [ blue_option_value ])
variant_c = product.variants.create!(option_values: [ black_option_value ])

stock_location.stock_items.create!(variant: variant_a, inventory_units: 10, backorderable: false)
stock_location.stock_items.create!(variant: variant_b, inventory_units: 8, backorderable: false)
stock_location.stock_items.create!(variant: variant_c, inventory_units: 5, backorderable: false)

order_a = Cart::NewCartService.new.call

Cart::AddItemService.new(order_id: order_a.id, options: { variant_id: variant_a.id, quantity: 3 }).call
Cart::AddItemService.new(order_id: order_a.id, options: { variant_id: variant_b.id, quantity: 1 }).call
Cart::AddItemService.new(order_id: order_a.id, options: { variant_id: variant_c.id, quantity: 2 }).call

order_a.reload
