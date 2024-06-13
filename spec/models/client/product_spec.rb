# == Schema Information
#
# Table name: client_products
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  client_id  :bigint           not null
#  product_id :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_client_products_on_client_id   (client_id)
#  index_client_products_on_product_id  (product_id)
#  index_client_products_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#  fk_rails_...  (product_id => products.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Client::Product do
  pending "add some examples to (or delete) #{__FILE__}"
end
