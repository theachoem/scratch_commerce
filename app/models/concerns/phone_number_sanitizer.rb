# required table to have :phone_number, :phone_number_intl, :country_code column
module PhoneNumberSanitizer
  extend ActiveSupport::Concern

  included do
    before_validation :sanitize_phone_number
  end

  private

  def sanitize_phone_number
    return if phone_number.blank?

    parser = PhoneNumberParser.call(
      phone_number: phone_number,
      country_code: country_code
    )

    self.country_code = parser.country_code
    self.phone_number = parser.national_phone_number
    self.intel_phone_number = parser.intel_phone_number
  end
end
