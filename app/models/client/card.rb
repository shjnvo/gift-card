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
#  index_client_cards_on_client_id   (client_id)
#  index_client_cards_on_product_id  (product_id)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#  fk_rails_...  (product_id => products.id)
#
class Client::Card < ApplicationRecord
  include CodeGenerator

  belongs_to :client
  belongs_to :product, class_name: '::Product'

  enum :state, %i[spending purchased cancelled]

  attribute :state, default: -> { :spending }

  before_validation :generate_serect_key, on: :create
  before_validation :set_price, on: :create
  before_validation :set_currency, on: :create

  validates :pin_code, presence: true, format: {
    with: /\A\d{8}\z/, message: I18n.t('card.message.pin_code_format')
  }

  private

  def generate_serect_key
    generate_code(:active_number, 9)
    active_number
  end

  def set_price
    self.price = product.price
  end

  def set_currency
    self.currency = product.currency
  end
end
