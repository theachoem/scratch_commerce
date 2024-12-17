module Cart
  class RemoveItemService
    attr_reader :order_id, :variant_id, :error

    def success? = @error == nil
    def initialize(order_id:, options: {})
      @order_id = order_id
      @variant_id = options[:variant_id]
      @error = nil
    end

    def call
      ActiveRecord::Base.transaction do
        begin
          remove_item
        rescue StandardError => e
          @error = e.message
          Rails.logger.error("Error during transaction: #{e.message}")
          raise ActiveRecord::Rollback
        end
      end
      success?
    end

    private

    def remove_item
      # 1 db operation
      order = Order.find(order_id)
      raise Exceptions::Cart::CartDoesNotAllowedToAddItem, "Current cart #{order.state}" unless order.allowed_modify_item?

      # 2 db operation
      order.line_items.where(variant_id: variant_id).delete_all

      # 5 db operation
      RecalculateService.new(order_id: order_id).call
    end
  end
end
