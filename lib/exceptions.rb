module Exceptions
  module Cart
    class QuantityNotFulfill < StandardError; end
    class CartDoesNotAllowedToAddItem < StandardError; end
  end
end
