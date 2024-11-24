module Cart
  class CreateCartService
    def initialize; end

    def call
      order = Order.new(channel: "default")
      order.save!
      order
    end
  end
end
