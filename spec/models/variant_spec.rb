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

  describe '#option_texts' do
    let(:option_type) { create(:option_type, presentation: 'Color') }
    let(:option_value) { create(:option_value, presentation: 'Red', option_type: option_type) }
    let(:product) { create(:product, option_types: [ option_type ]) }
    let(:variant) { create(:variant, product: product, option_values: [ option_value ]) }

    it 'fetches the option texts from cache if available' do
      Rails.cache.write(variant.option_texts_cache_key, 'Cached Option Texts')
      expect(variant.option_texts).to eq 'Cached Option Texts'
    end

    it 'calculates and caches the option texts when not cached' do
      expect(Rails.cache.read(variant.option_texts_cache_key)).to eq nil
      variant.option_texts # read & write to cache
      expect(Rails.cache.read(variant.option_texts_cache_key)).to eq "Color: Red"
    end
  end
end
