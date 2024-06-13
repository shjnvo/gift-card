require 'rails_helper'

RSpec.describe 'V1::Clients' do
  let!(:user) { create(:user, password: '123password$') }
  let!(:token) { user_login(user.email, '123password$') }

  describe 'POST v1/clients' do
    context 'without user login' do
      it 'cannot access' do
        post '/v1/clients'
        expect(response).to have_http_status(:unauthorized)
        expect(response.parsed_body['message']).to eq 'Please login to continue'
      end
    end

    context 'with user login' do
      it 'create client success' do
        params = { name: 'client1', email: 'test_client@example.com', payout_rate: 95 }
        post '/v1/clients', params:, headers: { 'Authentication' => token }

        expect(response).to have_http_status(:success)
        new_client = Client.first

        expect(new_client.name).to eq 'client1'
        expect(new_client.email).to eq 'test_client@example.com'
        expect(new_client.payout_rate).to eq 95
        expect(new_client.serect_key.present?).to be true
      end

      it 'cannot access with invalid token' do
        params = { name: 'client1', email: 'test_client@example.com', payout_rate: 95 }
        post '/v1/clients', params:, headers: { 'Authentication' => 'invalid_token' }
        expect(response).to have_http_status(:unauthorized)
        expect(response.parsed_body['message']).to eq 'Please login to continue'
      end

      it 'cannot create the client with brand.name is blank' do
        params = { name: '', email: 'test_client@example.com', payout_rate: 95 }
        post '/v1/clients', params:, headers: { 'Authentication' => token }

        expect(response).to have_http_status(422)
        expect(response.parsed_body['message']).to including("Name can't be blank")
      end

      it 'cannot create the client with brand.email is blank' do
        params = { name: 'client1', email: '', payout_rate: 95 }
        post '/v1/clients', params:, headers: { 'Authentication' => token }

        expect(response).to have_http_status(422)
        expect(response.parsed_body['message']).to including('Email is invalid')
      end

      it 'cannot create the client with brand.payout_rate less than 1' do
        params = { name: 'client1', email: 'test_client@example.com', payout_rate: 0 }
        post '/v1/clients', params:, headers: { 'Authentication' => token }

        expect(response).to have_http_status(422)
        expect(response.parsed_body['message']).to including('Payout rate must be greater than or equal to 1')
      end

      it 'cannot create the client with brand.payout_rate greater than 100' do
        params = { name: 'client1', email: 'test_client@example.com', payout_rate: 101 }
        post '/v1/clients', params:, headers: { 'Authentication' => token }

        expect(response).to have_http_status(422)
        expect(response.parsed_body['message']).to including('Payout rate must be less than or equal to 100')
      end

      it 'cannot create the client with brand.payout_rate is not integer' do
        params = { name: 'client1', email: 'test_client@example.com', payout_rate: 95.5 }
        post '/v1/clients', params:, headers: { 'Authentication' => token }

        expect(response).to have_http_status(422)
        expect(response.parsed_body['message']).to including('Payout rate must be an integer')
      end
    end
  end
end
