class NumberGenerator
  attr_accessor :length, :letters, :prefix, :model_class

  def initialize(options = {})
    @length = options[:length]
    @letters = options[:letters]
    @prefix = options[:prefix]
    @model_class = options[:model_class] || Order
  end

  def generate
    possible = (0..9).to_a
    possible += ("A".."Z").to_a if letters

    loop do
      # Make a random number.
      random = "#{prefix}#{(0...length).map { possible.sample }.join}"
      # Use the random number if no other order exists with it.
      if model_class.exists?(number: random)
        # If over half of all possible options are taken add another digit.
        length += 1 if total_count > (10**length / 2)
      else
        break random
      end
    end
  end

  private

  def total_count
    total_count ||= model_class.count
  end
end
