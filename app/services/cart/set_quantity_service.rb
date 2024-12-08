module Cart
  class SetQuantityService
    attr_reader :order_id, :variant_id, :quantity, :error

    def success? = @error == nil
    def initialize(order_id:, options: {})
      @order_id = order_id
      @variant_id = options[:variant_id]
      @quantity = [ options[:quantity]&.to_i, 1 ].max
      @error = nil
    end

    def call
      ActiveRecord::Base.transaction do
        begin
          set_quantity
        rescue StandardError => e
          @error = e.message
          Rails.logger.error("Error during transaction: #{e.message}")
          raise ActiveRecord::Rollback
        end
      end
      success?
    end

    private

    def set_quantity
      # 1 db operation
      variant = Variant.find(variant_id)
      raise QuantityNotFulfill, "Item only available #{variant.total_inventory_units}" unless variant.can_fulfill?(quantity)

      # 1 db operation
      order = Order.find(order_id)
      raise CartDoesNotAllowedToAddItem, "Current cart #{order.state}" unless order.allowed_modify_item?

      # 1 db operation
      order.line_items.where(variant_id: variant_id).update_all(quantity: quantity)

      # 5 db operation
      RecalculateService.new(order_id: order_id).call
    end
  end
end
