module Cart
  class NewCartService
    def initialize; end

    def call
      order = Order.create!
      order
    end
  end
end
