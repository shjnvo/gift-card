require 'rails_helper'

RSpec.describe 'V1::Sessions' do
  let!(:user) { create(:user, email: 'test_user@example.com', password: '123password$') }

  describe 'POST v1/login' do
    it 'user login success' do
      post '/v1/login', params: { email: user.email, password: '123password$' }
      expect(response).to have_http_status(:ok)
      expect(response.parsed_body.key?('token')).to be true
    end

    context 'when user login fails' do
      it 'with wrong email' do
        post '/v1/login', params: { email: 'wrong_email@example.com', password: '123password$' }
        expect(response).to have_http_status(:unauthorized)
        expect(response.parsed_body['message']).to eq 'Email or password was incorrect'
      end

      it 'with wrong password' do
        post '/v1/login', params: { email: user.email, password: 'wrong_password' }
        expect(response).to have_http_status(:unauthorized)
        expect(response.parsed_body['message']).to eq 'Email or password was incorrect'
      end
    end
  end

  describe 'DELETE v1/logout' do
    it 'user logout with no login' do
      delete '/v1/logout'
      expect(response).to have_http_status(:unauthorized)
      expect(response.parsed_body['message']).to eq 'Please login to continue'
    end

    it 'user logout after login' do
      token = get_token(user.email, '123password$')
      expect(user.reload.token.present?).to be true

      delete '/v1/logout', headers: { 'Authentication' => token }

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body['message']).to eq 'You have successfully logged out'
      expect(user.reload.token.present?).to be false
    end

    it 'user logout with invalid token' do
      token = 'invalid_token'

      delete '/v1/logout', headers: { 'Authentication' => token }
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
