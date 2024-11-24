require 'rails_helper'

RSpec.describe Cart::AddItemService do
  let(:stock_item) { create(:stock_item, inventory_units: 4) }
  let(:variant) { create(:variant, stock_items: [ stock_item ]) }

  let!(:order) { create(:order) }

  describe '#call' do
    it 'perform 21 db query' do
      subject = described_class.new(order_id: order.id, options: { variant_id: variant.id, quantity: 2 })
      query_count = count_queries { subject.call }

      expect(query_count).to eq 21
    end

    context 'when variant inventory units is more than needed' do
      let(:stock_item) { create(:stock_item, inventory_units: 3, backorderable: false) }
      let(:variant) { create(:variant, stock_items: [ stock_item ]) }

      it 'add item to cart' do
        subject = described_class.new(order_id: order.id, options: { variant_id: variant.id, quantity: 2 })
        subject.call

        expect(subject.success?).to be true
        expect(order.line_items.last.variant).to eq variant
        expect(order.line_items.last.quantity).to eq 2
      end
    end

    context 'when variant inventory units can not fulfil' do
      let(:stock_item) { create(:stock_item, inventory_units: 2, backorderable: false) }
      let(:variant) { create(:variant, stock_items: [ stock_item ]) }

      it 'add item to cart' do
        subject = described_class.new(order_id: order.id, options: { variant_id: variant.id, quantity: 3 })
        subject.call

        expect(order.line_items.size).to eq 0
        expect(subject.success?).to be false
        expect(subject.error).to eq "Item only available 2"
      end
    end
  end

  def count_queries
    query_counter = 0
    ActiveSupport::Notifications.subscribed(
      ->(_name, _start, _finish, _id, payload) {
        query_counter += 1 if payload[:sql] =~ /SELECT|INSERT|UPDATE|DELETE/i
      },
      "sql.active_record"
    ) do
      yield
    end
    query_counter
  end
end