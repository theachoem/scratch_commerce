class Address < ApplicationRecord
  attr_accessor :full_name

  belongs_to :province, optional: true
  belongs_to :country, optional: true

  has_many :orders

  validates :first_name, :last_name, :address1, presence: true
  validates :province, presence: true, if: :province_required?
  validates :country, presence: true, if: :country_required?
  validates :postal_code, presence: true, if: :postal_code_required?
  validates :phone_number, :phone_number_intl, :country_code, presence: true, if: :phone_number_required?

  before_validation :sanitize_phone_number, if: -> { phone_number.present? }
  before_validation :sanitize_alt_phone_number, if: -> { alt_phone_number.present? }
  before_validation :split_full_name, if: -> { full_name.present? }

  private

  def split_full_name
    names = full_name.split(" ", 2)
    self.first_name = names[0]
    self.last_name = names[1]
  end

  def sanitize_phone_number = sanitize_phone_attribute("phone_number")
  def sanitize_alt_phone_number = sanitize_phone_attribute("alt_phone_number")
  def sanitize_phone_attribute(attribute)
    parser = PhoneNumberParser.call(
      phone_number: send(attribute),
      country_code: country_code
    )

    self.country_code = parser.country_code
    send("#{attribute}=", parser.phone_number_national)
    send("#{attribute}_intl=", parser.phone_number_intl)
  end

  def province_required?
    true
  end

  def country_required?
    true
  end

  def postal_code_required?
    false
  end

  def phone_number_required?
    true
  end
end
