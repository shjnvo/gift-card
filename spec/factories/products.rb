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
FactoryBot.define do
  factory :product do
    name { 'My product' }
    brand
    price { '9.99' }
    currency { 'USD' }
    customize_fields { {} }
  end
end
