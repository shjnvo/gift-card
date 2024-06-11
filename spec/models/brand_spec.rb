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
require 'rails_helper'

RSpec.describe Brand do
  pending "add some examples to (or delete) #{__FILE__}"
end
