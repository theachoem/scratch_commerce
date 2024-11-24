require 'rails_helper'

RSpec.describe StockItem, type: :model do
  describe 'callbacks' do
    describe '#reload_variant_total_inventory_units_cache' do
      let(:stock_item_a) { create(:stock_item, inventory_units: 4) }
      let(:stock_item_b) { create(:stock_item, inventory_units: 3) }
      let(:variant) { create(:variant, stock_items: [ stock_item_a, stock_item_b ]) }

      it 'calls reload_variant_total_inventory_units_cache after commit' do
        expect(variant.total_inventory_units).to eq 7
        expect(Rails.cache.fetch(variant.total_inventory_units_cache_key)).to eq 7

        expect(stock_item_a).to receive(:reload_variant_total_inventory_units_cache).and_call_original
        stock_item_a.update!(inventory_units: 7)

        expect(Rails.cache.fetch(variant.total_inventory_units_cache_key)).to eq 10
        expect(variant.total_inventory_units).to eq 10
      end
    end

    describe '#reload_variant_backorderable_cache' do
      let(:stock_item_a) { create(:stock_item, backorderable: true) }
      let(:stock_item_b) { create(:stock_item, backorderable: false) }
      let(:variant) { create(:variant, stock_items: [ stock_item_a, stock_item_b ]) }

      it 'calls reload_variant_backorderable_cache after commit' do
        expect(variant.backorderable?).to eq true
        expect(Rails.cache.fetch(variant.backorderable_cache_key)).to eq true

        expect(stock_item_a).to receive(:reload_variant_backorderable_cache).and_call_original
        stock_item_a.update!(backorderable: false)

        expect(Rails.cache.fetch(variant.backorderable_cache_key)).to eq false
        expect(variant.backorderable?).to eq false
      end
    end
  end
end
