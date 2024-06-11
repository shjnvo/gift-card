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
FactoryBot.define do
  factory :brand do
    name { 'My brand' }
    state { true }
    customize_fields { {} }
  end
end
