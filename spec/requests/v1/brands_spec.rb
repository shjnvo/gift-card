require 'rails_helper'

RSpec.describe 'V1::Brands' do
  let!(:user) { create(:user, password: '123password$') }
  let!(:token) { get_token(user.email, '123password$') }

  describe 'POST v1/brands' do
    context 'without user login' do
      it 'cannot access' do
        post '/v1/brands'
        expect(response).to have_http_status(:unauthorized)
        expect(response.parsed_body['message']).to eq 'Please login to continue'
      end
    end

    context 'with user login' do
      it 'create brand success' do
        params = { name: 'brand1', customize_fields: { custom1: 'value1', custom2: 'value2' } }
        post '/v1/brands', params:, headers: { 'Authentication' => token }

        expect(response).to have_http_status(:success)
        new_brand = Brand.first

        expect(new_brand.name).to eq 'brand1'
        expect(new_brand.state).to eq 'active'
        expect(new_brand.customize_fields).to eq({ 'custom1' => 'value1', 'custom2' => 'value2' })
      end

      it 'cannot access with invalid token' do
        params = { name: 'brand1', customize_fields: { custom1: 'value1', custom2: 'value2' } }
        post '/v1/brands', params:, headers: { 'Authentication' => 'invalid_token' }
        expect(response).to have_http_status(:unauthorized)
        expect(response.parsed_body['message']).to eq 'Please login to continue'
      end

      it 'cannot create the brand with brand.name is NIL' do
        params = { customize_fields: { custom1: 'value1', custom2: 'value2' } }
        post '/v1/brands', params:, headers: { 'Authentication' => token }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body['message']).to including("Name can't be blank")
      end

      it 'cannot create the brand with brand.customize_fields over 5 fields' do
        params = {
          name: 'brand1',
          customize_fields: {
            custom1: 'value1', custom2: 'value2', custom3: 'value3',
            custom4: 'value4', custom5: 'value5', custom6: 'value6' }
        }
        post '/v1/brands', params:, headers: { 'Authentication' => token }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body['message']).to including('Customize fields cannot have more than 5 fields')
      end

      it 'cannot create the brand with brand.customize_fields is not a JSON' do
        params = { name: 'brand1', customize_fields: nil }
        post '/v1/brands', params:, headers: { 'Authentication' => token }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body['message']).to including('Customize fields must be a valid JSON object')

        params = { name: 'brand1', customize_fields: 'string' }
        post '/v1/brands', params:, headers: { 'Authentication' => token }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body['message']).to including('Customize fields must be a valid JSON object')

        params = { name: 'brand1', customize_fields: Array.new(1, 2) }
        post '/v1/brands', params:, headers: { 'Authentication' => token }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body['message']).to including('Customize fields must be a valid JSON object')
      end

      it 'cannot create the brand with brand.state the value is not a active or inactive' do
        params = { name: 'brand1', state: 'invalid', customize_fields: {} }
        post '/v1/brands', params:, headers: { 'Authentication' => token }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body['message']).to including('State is not included in the list')
      end
    end
  end

  describe 'PATCH v1/brands/:id/activate' do
    let!(:inactive_brand) { create(:brand, state: :inactive) }

    context 'without user login' do
      it 'cannot access' do
        patch "/v1/brands/#{inactive_brand.id}/activate"
        expect(response).to have_http_status(:unauthorized)
        expect(response.parsed_body['message']).to eq 'Please login to continue'
      end
    end

    context 'with user login' do
      it 'activate the brand' do
        expect(inactive_brand.inactive?).to be true

        patch "/v1/brands/#{inactive_brand.id}/activate", headers: { 'Authentication' => token }
        expect(response).to have_http_status(:success)

        expect(inactive_brand.reload.inactive?).to be false
      end

      it 'cannot access with invalid token' do
        expect(inactive_brand.inactive?).to be true

        patch "/v1/brands/#{inactive_brand.id}/activate", headers: { 'Authentication' => 'invalid_token' }
        expect(response).to have_http_status(:unauthorized)

        expect(inactive_brand.reload.inactive?).to be true
      end
    end
  end

  describe 'PATCH v1/brands/:id/inactivate' do
    let!(:active_brand) { create(:brand, state: :active) }

    context 'without user login' do
      it 'cannot access' do
        patch "/v1/brands/#{active_brand.id}/inactivate"
        expect(response).to have_http_status(:unauthorized)
        expect(response.parsed_body['message']).to eq 'Please login to continue'
      end
    end

    context 'with user login' do
      it 'activate the brand' do
        expect(active_brand.active?).to be true

        patch "/v1/brands/#{active_brand.id}/inactivate", headers: { 'Authentication' => token }
        expect(response).to have_http_status(:success)

        expect(active_brand.reload.active?).to be false
      end

      it 'cannot access with invalid token' do
        expect(active_brand.active?).to be true

        patch "/v1/brands/#{active_brand.id}/inactivate", headers: { 'Authentication' => 'invalid_token' }
        expect(response).to have_http_status(:unauthorized)

        expect(active_brand.reload.active?).to be true
      end
    end
  end
end
