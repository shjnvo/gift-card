# == Schema Information
#
# Table name: clients
#
#  id          :bigint           not null, primary key
#  email       :string           not null
#  name        :string
#  payout_rate :integer
#  serect_key  :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_clients_on_email       (email) UNIQUE
#  index_clients_on_serect_key  (serect_key) UNIQUE
#  index_clients_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Client < ApplicationRecord
  include CodeGenerator

  belongs_to :user

  has_many :cards, dependent: :destroy
  has_many :client_products, class_name: 'Client::Product', dependent: :destroy
  has_many :products, through: :client_products, dependent: :destroy

  validates :name, presence: true
  validates :email, uniqueness: true, format: URI::MailTo::EMAIL_REGEXP
  validates :payout_rate, presence: true,
                          numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 100, only_integer: true }

  before_validation :generate_serect_key, on: :create

  private

  def generate_serect_key
    generate_code(:serect_key, 18)
  end
end
