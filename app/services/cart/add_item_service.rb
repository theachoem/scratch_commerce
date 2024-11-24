module Cart
  class QuantityNotFulfill < StandardError; end
  class CartDoesNotAllowedToAddItem < StandardError; end

  class AddItemService
    attr_reader :order_id, :variant_id, :quantity, :error

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

    def success?
      @error == nil
    end

    private

    def add_item
      # 1 db operation
      variant = Variant.find(variant_id)
      raise QuantityNotFulfill, "Item only available #{variant.total_inventory_units}" unless variant.can_fulfill?(quantity)

      # 8 db operation
      order = Order.includes(:adjustments, :all_adjustments, line_items: :adjustments).find(order_id)
      raise CartDoesNotAllowedToAddItem, "Current cart #{cart.state}" if order.allowed_add_item?

      # 0 db operation
      line_item = construct_item(order, variant, quantity)

      # 1 db operation
      order.line_items << line_item

      # 4 db operation
      update_order_with_new_item(order, line_item)

      # 10 operation
      ActiveRecord::Base.logger = Logger.new(STDOUT)
      order.save!
      ActiveRecord::Base.logger = nil
    end

    def construct_item(order, variant, quantity)
      line_item = LineItem.new(variant: variant, quantity: quantity)
      line_item.unit_price = variant.unit_price_for(order.currency)
      line_item.subtotal = line_item.unit_price * quantity
      line_item.currency = order.currency
      line_item
    end

    def update_order_with_new_item(order, line_item)
      order.line_items.each { |item| item.adjustments.reset }

      # 1 db operation
      order.all_adjustments.delete_all

      # Re-apply existing promotions only for eligible ones
      # apply_existing_promotions_to_order(order)

      # Calculate adjustments based on taxes
      # apply_taxes_to_order(order) if order.zone.present?

      # Recalculate adjustments and totals for each line item
      order.line_items.each do |item|
        item.adjustment_total = order.all_adjustments.select { |adjustment| adjustment.adjustable == item }.sum(:amount)
        item.total = item.subtotal + item.adjustment_total
      end

      # 0 db operation
      order.state = :cart
      order.payment_state = nil
      order.currency ||= order.store.default_currency
      order.subtotal = order.line_items.sum(&:total)
      order.adjustment_total = order.adjustments.sum(&:amount)
      order.total = order.subtotal + order.adjustment_total
      order.paid_total = 0
    end

    # def apply_existing_promotions_to_order(order)
    #   promotions = order.promotions.select { |promotion| promotion.rules.all? { |rule| rule.eligible?(order) } }
    #   order.order_promotions.clear
    #   promotions.each do |promotion|
    #     promotion.actions.each do |action|
    #       order.all_adjustments += action.generate_adjustments(order)
    #     end
    #   end
    # end

    # Apply taxes to the order in an efficient manner
    # def apply_taxes_to_order(order)
    #   adjustments = []
    #   order.line_items.each do |line_item|
    #     next unless line_item.product.tax_category
    #     tax_rate = line_item.product.tax_category.active_tax_rates.find { |rate| rate.zone.id == order.zone.id }
    #     if tax_rate
    #       adjustments << Adjustment.new(source: tax_rate, order: order, adjustable: line_item, amount: tax_rate.amount)
    #     end
    #   end
    #   # Add tax adjustments to the order
    #   order.all_adjustments.concat(adjustments)
    # end
  end
end
