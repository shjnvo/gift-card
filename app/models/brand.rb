class Brand < ApplicationRecord
  include CustomizeFieldsValidatable

  validates :name, presence: true

  enum :state, { active: true, inactive: false }, validate: true
end
