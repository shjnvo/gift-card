# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string           not null
#  password_digest :string
#  token           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
  include CodeGenerator

  has_secure_password

  validates :password, length: { minimum: 8 }, on: :create
  validates :email, uniqueness: true, format: URI::MailTo::EMAIL_REGEXP

  def generate_token!
    generate_code!(:token, 64)
    token
  end

  def revoke_token!
    update(token: nil)
  end
end
