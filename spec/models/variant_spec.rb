require 'rails_helper'

RSpec.describe Variant, type: :model do
  let!(:default_store) { create(:store, is_default: true) }

  it { should belong_to(:product) }
  it { should have_many_attached(:images) }
  it { should have_many(:option_value_variants).order(:position) }
  it { should have_many(:option_values).through(:option_value_variants) }
  it { should have_many(:inventory_units) }
  it { should have_many(:stock_items) }
  it { should have_many(:stock_locations).through(:stock_items) }
  it { should have_many(:line_items) }
  it { should have_many(:orders).through(:line_items) }

  describe 'validation' do
    it { should validate_presence_of(:product) }
    it { should validate_presence_of(:cost_price) }
    it { should validate_presence_of(:markup) }

    context 'when markup is less than 0' do
      it { should_not allow_value(-1).for(:markup) }
    end

    context 'when markup is greater than 100' do
      it { should_not allow_value(101).for(:markup) }
    end
  end

  describe '#option_texts' do
    let(:option_type) { create(:option_type, presentation: 'Color') }
    let(:option_value) { create(:option_value, presentation: 'Red', option_type: option_type) }
    let(:product) { create(:product, option_types: [ option_type ]) }
    let(:variant) { build(:variant, product: product, option_values: [ option_value ]) }

    before(:each) do
      Rails.cache.clear
    end

    it 'fetches the option texts from cache if available' do
      variant.save!

      Rails.cache.write(variant.option_texts_cache_key, 'Cached Option Texts')
      expect(variant.option_texts).to eq 'Cached Option Texts'
    end

    it 'calculates and caches the option texts when not cached' do
      variant.save! # read & write to cache

      expect(Rails.cache.read(variant.option_texts_cache_key)).to eq "Color: Red"
    end
  end
end
