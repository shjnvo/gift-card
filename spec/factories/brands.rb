FactoryBot.define do
  factory :brand do
    name { 'My brand' }
    state { true }
    customize_fields { {} }
  end
end
