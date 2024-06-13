require 'rails_helper'

RSpec.describe 'V1::Clients::Cards' do
  let!(:user) { create(:user) }
  let!(:client) { create(:client, user:, payout_rate: 95) }
  let!(:product) { create(:product, price: 100) }

  describe 'POST /v1/clients/:client_id/cards' do
    it 'create card success with is pin_code' do
      create(:client_product, client:, user:, product:)
      data = { serect_key: client.serect_key, product_id: product.id, pin_code: '12345678' }
      post "/v1/clients/#{client.id}/cards", params: data
      expect(response).to have_http_status(:success)
      card = Client::Card.first

      expect(response.parsed_body['currency']).to eq product.currency
      expect(response.parsed_body['price']).to eq card.price.to_s
      expect(response.parsed_body['active_number']).to be_nil
      expect(card.pin_code?).to be true
      expect(response.parsed_body['pin_code']).to eq '12345678'
    end

    it 'cannot create card when the pin_code format is not digits' do
      create(:client_product, client:, user:, product:)
      data = { serect_key: client.serect_key, product_id: product.id, pin_code: 'qwe45678' }
      post "/v1/clients/#{client.id}/cards", params: data
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.parsed_body['message']).to including 'Pin code must be 8 digits'
    end

    it 'cannot create card when the pin_code is blank' do
      create(:client_product, client:, user:, product:)
      data = { serect_key: client.serect_key, product_id: product.id, pin_code: '' }
      post "/v1/clients/#{client.id}/cards", params: data
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.parsed_body['message']).to including 'Pin code must be 8 digits'
    end

    it 'cannot create card when product not belong to the client' do
      data = { serect_key: client.serect_key, product_id: product.id }
      post "/v1/clients/#{client.id}/cards", params: data
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.parsed_body['message']).to eq 'Product was not existed'
    end

    it 'cannot create card when product is inactive' do
      product.inactive!
      create(:client_product, client:, user:, product:)
      data = { serect_key: client.serect_key, product_id: product.id }
      post "/v1/clients/#{client.id}/cards", params: data
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.parsed_body['message']).to eq 'Product was not existed'
    end

    it 'cannot create card when product belong to the brand is inactive' do
      product.brand.inactive!
      create(:client_product, client:, user:, product:)
      data = { serect_key: client.serect_key, product_id: product.id }
      post "/v1/clients/#{client.id}/cards", params: data
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.parsed_body['message']).to eq 'Product was not existed'
    end

    it 'cannot create card when client id is incorrect' do
      client2 = create(:client, user:, payout_rate: 80)
      create(:client_product, client: client2, user:, product:)

      data = { serect_key: client.serect_key, product_id: product.id }
      post "/v1/clients/#{client2.id}/cards", params: data
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.parsed_body['message']).to eq 'Client id or serect key was incorrect'
    end

    it 'cannot create card when client serect_key is incorrect' do
      client2 = create(:client, user:, payout_rate: 80)
      create(:client_product, client:, user:, product:)

      data = { serect_key: client2.serect_key, product_id: product.id }
      post "/v1/clients/#{client.id}/cards", params: data
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.parsed_body['message']).to eq 'Client id or serect key was incorrect'
    end
  end

  describe 'PATCH /v1/clients/:client_id/cards/:id/cancel' do
    it 'cancel the card created' do
      card = create(:client_card, client:, product:)
      expect(card.spending?).to be true

      data = { serect_key: client.serect_key }
      patch "/v1/clients/#{client.id}/cards/#{card.id}/cancel", params: data
      expect(response).to have_http_status(:success)
      expect(response.parsed_body['message']).to eq 'Card was successfully cancelled'

      expect(card.reload.cancelled?).to be true
    end

    it 'cannnot be cancelled the card do not belong to the client' do
      client2 = create(:client, user:, payout_rate: 80)

      card = create(:client_card, client:, product:)
      expect(card.spending?).to be true

      data = { serect_key: client2.serect_key }
      patch "/v1/clients/#{client2.id}/cards/#{card.id}/cancel", params: data
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.parsed_body['message']).to eq 'Card id was incorrect'
    end

    it 'cannnot be cancelled the card id is incorrect' do
      data = { serect_key: client.serect_key }
      patch "/v1/clients/#{client.id}/cards/999/cancel", params: data
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.parsed_body['message']).to eq 'Card id was incorrect'
    end

    it 'cannnot be cancelled the client serect key is incorrect' do
      card = create(:client_card, client:, product:)
      expect(card.spending?).to be true

      data = { serect_key: 'invalid_key' }
      patch "/v1/clients/#{client.id}/cards/#{card.id}/cancel", params: data
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.parsed_body['message']).to eq 'Client id or serect key was incorrect'
    end

    it 'cannnot be cancelled the client id is incorrect' do
      card = create(:client_card, client:, product:)
      expect(card.spending?).to be true

      data = { serect_key: client.serect_key }
      patch "/v1/clients/9999/cards/#{card.id}/cancel", params: data
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.parsed_body['message']).to eq 'Client id or serect key was incorrect'
    end
  end
end
