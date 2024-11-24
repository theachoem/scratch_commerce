module Cart
  class RemoveItemService
    attr_reader :order_id, :line_item_id, :error

    def success? = @error == nil
    def initialize(order_id:, options: {})
      @order_id = order_id
      @line_item_id = options[:line_item_id]
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
      # 2 db operation
      LineItem.where(order_id: order_id, id: line_item_id).delete_all

      # 5 db operation
      RecalculateService.new(order_id: order_id).call
    end
  end
end
