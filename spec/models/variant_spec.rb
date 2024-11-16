require 'rails_helper'

RSpec.describe Variant, type: :model do
  it { should belong_to(:product) }
  it { should have_many(:variant_images).order(:position).dependent(:destroy) }
  it { should have_many(:option_value_variants).order(:position) }
  it { should have_many(:option_values).through(:option_value_variants) }
  it { should have_many(:inventory_units) }
  it { should have_many(:stock_items) }
  it { should have_many(:stock_locations).through(:stock_items) }
  it { should have_many(:line_items) }
  it { should have_many(:orders).through(:line_items) }
end
