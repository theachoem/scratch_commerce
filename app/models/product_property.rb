class ProductProperty < ApplicationRecord
  acts_as_list scope: :property

  belongs_to :product, optional: false
  belongs_to :property, optional: false

  validates_presence_of :value
  validates_numericality_of :value, only_integer: true, if: :attr_type_integer?
  validates_numericality_of :value, only_float: true, if: :attr_type_float?
  validates :value, inclusion: %w[1 0], if: :attr_type_boolean?

  Property.attr_types.keys.each do |attr_type|
    define_method "attr_type_#{attr_type}?" do
      property&.send("attr_type_#{attr_type}?")
    end
  end
end
