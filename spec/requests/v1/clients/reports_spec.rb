require 'rails_helper'

RSpec.describe 'V1::Clients::Reports' do
  let!(:user) { create(:user) }
  let!(:client) { create(:client, user:, payout_rate: 95) }
  let!(:product) { create(:product, price: 100) }
  let!(:card_spending) do
    create_list(:client_card, 5, client:, product:, state: :spending, updated_at: 5.days.ago)
  end
  let!(:card_cancelled) do
    create_list(:client_card, 5, client:, product:, state: :cancelled, updated_at: 5.days.ago)
  end

  describe 'GET /v1/clients/:client_id/repots' do
    it 'get the report of recently a month data when without parms start_date and end_date' do
      data = { serect_key: client.serect_key }
      get "/v1/clients/#{client.id}/repots", params: data
      expect(response).to have_http_status(:success)

      expect(response.parsed_body['total_spendings']).to eq card_spending.count
      expect(response.parsed_body['total_cancellations']).to eq card_cancelled.count

      response_spending_ids = JSON.parse(response.parsed_body['spendings']).pluck('id')
      response_cancelled_ids = JSON.parse(response.parsed_body['cancellations']).pluck('id')

      expect(response_spending_ids).to eq(card_spending.pluck(:id))
      expect(response_cancelled_ids).to eq(card_cancelled.pluck(:id))
    end

    context 'when the report with param start_date' do
      it 'have data in date range' do
        data = { serect_key: client.serect_key, start_date: 7.days.ago }
        get "/v1/clients/#{client.id}/repots", params: data

        expect(response).to have_http_status(:success)
        expect(response.parsed_body['total_spendings']).to eq card_spending.count
        expect(response.parsed_body['total_cancellations']).to eq card_cancelled.count

        response_spending_ids = JSON.parse(response.parsed_body['spendings']).pluck('id')
        response_cancelled_ids = JSON.parse(response.parsed_body['cancellations']).pluck('id')

        expect(response_spending_ids).to eq(card_spending.pluck(:id))
        expect(response_cancelled_ids).to eq(card_cancelled.pluck(:id))
      end

      it 'have not data in date range' do
        data = { serect_key: client.serect_key, start_date: 4.days.ago }
        get "/v1/clients/#{client.id}/repots", params: data

        expect(response).to have_http_status(:success)
        expect(response.parsed_body['total_spendings']).to eq 0
        expect(response.parsed_body['total_cancellations']).to eq 0
        expect(response.parsed_body['spendings']).to eq '[]'
        expect(response.parsed_body['cancellations']).to eq '[]'
      end
    end

    context 'when the report with param end_date' do
      it 'have data in date range' do
        data = { serect_key: client.serect_key, end_date: 3.days.ago }
        get "/v1/clients/#{client.id}/repots", params: data

        expect(response).to have_http_status(:success)
        expect(response.parsed_body['total_spendings']).to eq card_spending.count
        expect(response.parsed_body['total_cancellations']).to eq card_cancelled.count

        response_spending_ids = JSON.parse(response.parsed_body['spendings']).pluck('id')
        response_cancelled_ids = JSON.parse(response.parsed_body['cancellations']).pluck('id')

        expect(response_spending_ids).to eq(card_spending.pluck(:id))
        expect(response_cancelled_ids).to eq(card_cancelled.pluck(:id))
      end

      it 'have not data in date range' do
        data = { serect_key: client.serect_key, end_date: 6.days.ago }
        get "/v1/clients/#{client.id}/repots", params: data

        expect(response).to have_http_status(:success)
        expect(response.parsed_body['total_spendings']).to eq 0
        expect(response.parsed_body['total_cancellations']).to eq 0
        expect(response.parsed_body['spendings']).to eq '[]'
        expect(response.parsed_body['cancellations']).to eq '[]'
      end
    end

    context 'when the report with params start_date and end_date' do
      it 'have data in date range' do
        data = { serect_key: client.serect_key, start_date: 7.days.ago, end_date: 3.days.ago }
        get "/v1/clients/#{client.id}/repots", params: data

        expect(response).to have_http_status(:success)
        expect(response.parsed_body['total_spendings']).to eq card_spending.count
        expect(response.parsed_body['total_cancellations']).to eq card_cancelled.count

        response_spending_ids = JSON.parse(response.parsed_body['spendings']).pluck('id')
        response_cancelled_ids = JSON.parse(response.parsed_body['cancellations']).pluck('id')

        expect(response_spending_ids).to eq(card_spending.pluck(:id))
        expect(response_cancelled_ids).to eq(card_cancelled.pluck(:id))
      end

      it 'have not data in date range' do
        data = { serect_key: client.serect_key, start_date: 4.days.ago, end_date: 2.days.ago }
        get "/v1/clients/#{client.id}/repots", params: data

        expect(response).to have_http_status(:success)
        expect(response.parsed_body['total_spendings']).to eq 0
        expect(response.parsed_body['total_cancellations']).to eq 0
        expect(response.parsed_body['spendings']).to eq '[]'
        expect(response.parsed_body['cancellations']).to eq '[]'
      end
    end
  end
end
