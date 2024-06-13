# == Schema Information
#
# Table name: products
#
#  id               :bigint           not null, primary key
#  currency         :string
#  customize_fields :jsonb
#  name             :string
#  price            :decimal(, )
#  state            :boolean          default("active"), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  brand_id         :bigint           not null
#
# Indexes
#
#  index_products_on_brand_id  (brand_id)
#
# Foreign Keys
#
#  fk_rails_...  (brand_id => brands.id)
#
require 'rails_helper'

RSpec.describe Product do
  describe 'Product methods' do
    let!(:product) { create(:product) }

    it '#available? is false when brand is inactive and product is active' do
      product.brand.inactive!
      expect(product.active?).to be true
      expect(product.available?).to be false
    end

    it '#available? is false when brand is active and product is inactive' do
      product.inactive!
      expect(product.brand.active?).to be true
      expect(product.available?).to be false
    end

    it '#available? is true when brand is active and product is active' do
      expect(product.brand.active?).to be true
      expect(product.active?).to be true
      expect(product.available?).to be true
    end
  end
end
