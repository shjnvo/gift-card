# == Schema Information
#
# Table name: products
#
#  id               :bigint           not null, primary key
#  name             :string
#  brand_id         :bigint           not null
#  price            :decimal(, )
#  currency         :string
#  state            :boolean          default("active"), not null
#  customize_fields :jsonb
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Product < ApplicationRecord
  include CustomizeFieldsValidatable

  belongs_to :brand

  enum :state, { active: true, inactive: false }, validate: true

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :currency, presence: true, inclusion: { in: %w[USD EUR GBP JPY AUD CAD MYR SGD VND] }
end
