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
require 'rails_helper'

RSpec.describe Client do
  pending "add some examples to (or delete) #{__FILE__}"
end
