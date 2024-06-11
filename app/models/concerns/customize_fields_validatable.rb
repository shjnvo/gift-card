module CustomizeFieldsValidatable
  extend ActiveSupport::Concern

  included do
    validate :validate_customize_fields
  end

  private

  def validate_customize_fields
    if customize_fields.is_a?(Hash)
      errors.add(:customize_fields, 'cannot have more than 5 fields') if customize_fields.keys.size > 5
    else
      errors.add(:customize_fields, 'must be a valid JSON object')
    end
  end
end
