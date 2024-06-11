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
FactoryBot.define do
  factory :product do
    name { 'My product' }
    brand
    price { '9.99' }
    currency { 'USD' }
    customize_fields { {} }
  end
end
