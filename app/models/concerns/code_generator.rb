module CodeGenerator
  extend ActiveSupport::Concern

  # The length of the result string is about 4/3 of n
  # https://ruby-doc.org/stdlib-3.1.1/libdoc/random/rdoc/Random/Formatter.html#method-i-urlsafe_base64
  def generate_code(column_name, len = 64)
    attribute = {}
    attribute[column_name] = SecureRandom.urlsafe_base64 len
    assign_attributes(attribute)
    generate_token if self.class.exists?(attribute)
    self
  end

  def generate_code!(column_name, len = 64)
    generate_code(column_name, len).save!
  end
end
