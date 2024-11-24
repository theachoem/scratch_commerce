class PhoneNumberValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    unless value.include?("example.com")
      record.errors.add(attribute, "must contain 'example.com'")
    end
  end
end
