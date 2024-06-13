require 'rails_helper'

RSpec.describe 'V1::Clients::Products' do
  let!(:user) { create(:user, password: '123password$') }
  let!(:token) { get_token(user.email, '123password$') }
  let!(:client) { create(:client, user:, name: 'client1', email: 'test_client@example.com', payout_rate: 95) }
  let!(:product) { create(:product, price: 100) }

  describe 'POST /v1/clients/:client_id/products' do
    context 'without user login' do
      it 'cannot access' do
        post "/v1/clients/#{client.id}/products"
        expect(response).to have_http_status(:unauthorized)
        expect(response.parsed_body['message']).to eq 'Please login to continue'
      end
    end

    context 'with user login' do
      it 'create client_product success' do
        params = { product_ids: [product.id] }
        post "/v1/clients/#{client.id}/products", params:, headers: { 'Authentication' => token }

        expect(response).to have_http_status(:success)

        expect(response.parsed_body['name']).to eq 'client1'
        expect(response.parsed_body['email']).to eq 'test_client@example.com'
        expect(response.parsed_body['payout_rate']).to eq 95
        expect(client.products.first.id).to eq product.id
        expect(response.parsed_body['products'][0]['currency']).to eq 'USD'
        expect(response.parsed_body['products'][0]['name']).to eq 'My product'
        expect(response.parsed_body['products'][0]['price']).to eq '100.0'
      end

      it 'create client_product success with mutiple product_ids' do
        product2 = create(:product, price: 200, currency: 'MYR', name: 'produc_2')
        params = { product_ids: [product.id, product2.id] }
        post "/v1/clients/#{client.id}/products", params:, headers: { 'Authentication' => token }

        expect(response).to have_http_status(:success)

        expect(response.parsed_body['name']).to eq 'client1'
        expect(response.parsed_body['email']).to eq 'test_client@example.com'
        expect(response.parsed_body['payout_rate']).to eq 95
        expect(client.products.pluck(:id)).to including(product.id, product2.id)
        expect(response.parsed_body['products'][0]['currency']).to eq 'USD'
        expect(response.parsed_body['products'][0]['name']).to eq 'My product'
        expect(response.parsed_body['products'][0]['price']).to eq '100.0'
        expect(response.parsed_body['products'][1]['currency']).to eq 'MYR'
        expect(response.parsed_body['products'][1]['name']).to eq 'produc_2'
        expect(response.parsed_body['products'][1]['price']).to eq '200.0'
      end

      it 'cannot create client_product with assign specify product not existed' do
        params = { product_ids: [9999] }
        post "/v1/clients/#{client.id}/products", params:, headers: { 'Authentication' => token }

        expect(response).to have_http_status(:success)

        expect(response.parsed_body['name']).to eq 'client1'
        expect(response.parsed_body['email']).to eq 'test_client@example.com'
        expect(response.parsed_body['payout_rate']).to eq 95
        expect(client.products.blank?).to be true
        expect(response.parsed_body['products'].blank?).to be true
      end

      it 'do not allow product is inactive' do
        product.inactive!
        params = { product_ids: [product.id] }
        post "/v1/clients/#{client.id}/products", params:, headers: { 'Authentication' => token }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body['message']).to eq "Product id #{product.id} was unavailable"
      end

      it 'do not allow brand of product is inactive' do
        product.brand.inactive!
        expect(product.active?).to be true

        params = { product_ids: [product.id] }
        post "/v1/clients/#{client.id}/products", params:, headers: { 'Authentication' => token }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body['message']).to eq "Product id #{product.id} was unavailable"
      end

      it 'can not make client_product with client_id no existed' do
        params = { product_ids: [product.id] }
        post '/v1/clients/client_id_no_existed/products', params:, headers: { 'Authentication' => token }

        expect(response).to have_http_status(:no_content)
      end
    end
  end
end
