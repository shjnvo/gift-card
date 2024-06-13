# == Schema Information
#
# Table name: products
#
#  id               :bigint           not null, primary key
#  currency         :string
#  customize_fields :jsonb
#  name             :string
#  price            :decimal(, )
#  state            :boolean          default("active"), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  brand_id         :bigint           not null
#
# Indexes
#
#  index_products_on_brand_id  (brand_id)
#
# Foreign Keys
#
#  fk_rails_...  (brand_id => brands.id)
#
class Product < ApplicationRecord
  include CustomizeFieldsValidatable

  belongs_to :brand

  enum :state, { active: true, inactive: false }, validate: true

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :currency, presence: true, inclusion: { in: %w[USD EUR GBP JPY AUD CAD MYR SGD VND] }

  def available?
    brand.active? && active?
  end
end
