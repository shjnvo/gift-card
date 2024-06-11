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
require 'rails_helper'

RSpec.describe Product do
  pending "add some examples to (or delete) #{__FILE__}"
end
