# == Schema Information
#
# Table name: brands
#
#  id               :bigint           not null, primary key
#  name             :string
#  state            :boolean          default("active"), not null
#  customize_fields :jsonb
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Brand < ApplicationRecord
  include CustomizeFieldsValidatable

  validates :name, presence: true

  enum :state, { active: true, inactive: false }, validate: true

  has_many :products, dependent: :destroy
end
