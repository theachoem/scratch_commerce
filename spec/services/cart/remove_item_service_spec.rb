require 'rails_helper'

RSpec.describe Cart::RemoveItemService do
  let(:stock_item) { create(:stock_item, inventory_units: 4) }
  let(:variant) { create(:variant, stock_items: [ stock_item ]) }
  let(:order) { create(:order) }

  before do
    Cart::AddItemService.new(order_id: order.id, options: { variant_id: variant.id, quantity: 1 }).call
  end

  describe '#call' do
    it 'perform 7 db query' do
      line_item = order.line_items.first

      subject = described_class.new(order_id: order.id, options: { line_item_id: line_item.id })
      query_count = count_queries { subject.call }

      expect(order.line_items.size).to eq 0
      expect(query_count).to eq 7
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
