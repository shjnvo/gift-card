require 'rails_helper'

RSpec.describe User do
  describe 'User methods' do
    let!(:user) { create(:user) }

    it '#generate_token!' do
      user.generate_token!
      expect(user.token.present?).to be(true)
    end

    it '#revoke_token!' do
      user.revoke_token!
      expect(user.token.present?).to be(false)
    end
  end
end
