# This is used for other service.
# Not recommended for use outside of its service scope as there is no transaction handled here and it throw ERROR.
module Cart
  class RecalculateService
    attr_reader :order_id

    def initialize(order_id:)
      @order_id = order_id
    end

    def call
      order = Order.find(order_id)
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
      order.assign_attributes(
        item_count: order.line_items.size,
        payment_state: nil,
        currency: order.currency || order.store.default_currency,
        subtotal: order.line_items.sum(&:total),
        adjustment_total: order.adjustments.sum(&:amount),
        total: order.subtotal + order.adjustment_total,
        paid_total: 0
      )

      # 10 operation
      ActiveRecord::Base.logger = Logger.new(STDOUT)
      order.save!
      ActiveRecord::Base.logger = nil
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
