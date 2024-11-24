class PhoneNumberParser < BaseInteractor
  # :phone_number, :country_code
  def call
    sanitize_phone_number
  end

  def sanitize_phone_number
    phone_parser = Phonelib.parse(phone_number, country_code)
    return if phone_parser.international.blank?

    context.phone_number_intl = phone_parser.international.gsub!(/[() -]/, "")
    context.phone_number_national = phone_parser.national.gsub!(/[() -]/, "")
  end

  def phone_number
    context.phone_number&.strip
  end

  def country_code
    context.country_code ||= Phonelib.default_country
  end
end
