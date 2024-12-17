module Cart
  class AddItemService
    attr_reader :order_id, :variant_id, :quantity, :error

    def success? = @error == nil
    def initialize(order_id:, options: {})
      @order_id = order_id
      @variant_id = options[:variant_id]
      @quantity = options[:quantity]
      @error = nil
    end

    def call
      ActiveRecord::Base.transaction do
        begin
          add_item
        rescue StandardError => e
          @error = e.message
          Rails.logger.error("Error during transaction: #{e.message}")
          raise ActiveRecord::Rollback
        end
      end
      success?
    end

    private

    def add_item
      # 1 db operation
      variant = Variant.find(variant_id)
      raise Exceptions::Cart::QuantityNotFulfill, "Item only available #{variant.total_inventory_units}" unless variant.can_fulfill?(quantity)

      # 1 db operation
      order = Order.find(order_id)
      raise Exceptions::Cart::CartDoesNotAllowedToAddItem, "Current cart #{order.state}" unless order.allowed_modify_item?

      # 2 db operation
      order.line_items << construct_item(order, variant, quantity)

      # 7 db operation
      RecalculateService.new(order_id: order_id).call
    end

    def construct_item(order, variant, quantity)
      line_item = LineItem.new(variant: variant, quantity: quantity)
      line_item.unit_price = variant.unit_price_for(order.currency)
      line_item.subtotal = line_item.unit_price * quantity
      line_item.currency = order.currency
      line_item
    end
  end
end
