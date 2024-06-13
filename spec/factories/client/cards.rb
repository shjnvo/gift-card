# == Schema Information
#
# Table name: client_cards
#
#  id            :bigint           not null, primary key
#  active_number :string
#  currency      :string
#  pin_code      :string
#  price         :decimal(, )
#  state         :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  client_id     :bigint           not null
#  product_id    :bigint           not null
#
# Indexes
#
#  index_client_cards_on_active_number  (active_number) UNIQUE
#  index_client_cards_on_client_id      (client_id)
#  index_client_cards_on_product_id     (product_id)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#  fk_rails_...  (product_id => products.id)
#
FactoryBot.define do
  factory :client_card, class: 'Client::Card' do
    client
    product
    active_number { 'active_number' }
    pin_code { '12345678' }
  end
end
