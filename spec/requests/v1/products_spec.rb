require 'rails_helper'

RSpec.describe 'V1::Products' do
  let!(:user) { create(:user, password: '123password$') }
  let!(:token) { get_token(user.email, '123password$') }
  let!(:brand) { create(:brand) }

  describe 'POST v1/brands/:brand_id/products' do
    context 'without user login' do
      it 'cannot access' do
        post "/v1/brands/#{brand.id}/products"
        expect(response).to have_http_status(:unauthorized)
        expect(response.parsed_body['message']).to eq 'Please login to continue'
      end
    end

    context 'with user login' do
      it 'create product success' do
        params = {
          name: 'product1', price: 100.0, currency: 'USD',
          customize_fields: { custom1: 'value1', custom2: 'value2' }
        }
        post "/v1/brands/#{brand.id}/products", params:, headers: { 'Authentication' => token }

        expect(response).to have_http_status(:success)
        new_product = Product.first

        expect(new_product.name).to eq 'product1'
        expect(new_product.state).to eq 'active'
        expect(new_product.price).to eq 100
        expect(new_product.currency).to eq 'USD'
        expect(new_product.customize_fields).to eq({ 'custom1' => 'value1', 'custom2' => 'value2' })
      end

      it 'cannot access with invalid token' do
        params = {
          name: 'product1', price: 100.0, currency: 'USD',
          customize_fields: { custom1: 'value1', custom2: 'value2' }
        }
        post "/v1/brands/#{brand.id}/products", params:, headers: { 'Authentication' => 'invalid_token' }

        expect(response).to have_http_status(:unauthorized)
        expect(response.parsed_body['message']).to eq 'Please login to continue'
      end

      it 'cannot create the product with product.name is blank' do
        params = {
          name: '', price: 100.0, currency: 'USD',
          customize_fields: { custom1: 'value1', custom2: 'value2' }
        }
        post "/v1/brands/#{brand.id}/products", params:, headers: { 'Authentication' => token }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body['message']).to including("Name can't be blank")
      end

      it 'cannot create the product with product.currency is blank' do
        params = {
          name: 'product1', price: 100.0, currency: '',
          customize_fields: { custom1: 'value1', custom2: 'value2' }
        }
        post "/v1/brands/#{brand.id}/products", params:, headers: { 'Authentication' => token }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body['message']).to including("Currency can't be blank")
      end

      it 'cannot create the product with product.currency not included the list' do
        params = {
          name: 'product1', price: 100.0, currency: 'AAA',
          customize_fields: { custom1: 'value1', custom2: 'value2' }
        }
        post "/v1/brands/#{brand.id}/products", params:, headers: { 'Authentication' => token }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body['message']).to including('Currency is not included in the list')
      end

      it 'cannot create the product with product.price is blank' do
        params = {
          name: 'product1', price: nil, currency: 'USD',
          customize_fields: { custom1: 'value1', custom2: 'value2' }
        }
        post "/v1/brands/#{brand.id}/products", params:, headers: { 'Authentication' => token }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body['message']).to including("Price can't be blank")
      end

      it 'cannot create the product with product.price is not numeric' do
        params = {
          name: 'product1', price: '100,00', currency: 'USD',
          customize_fields: { custom1: 'value1', custom2: 'value2' }
        }
        post "/v1/brands/#{brand.id}/products", params:, headers: { 'Authentication' => token }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body['message']).to including('Price is not a number')
      end

      it 'cannot create the product with product.customize_fields is not a JSON' do
        params = {
          name: 'product1', price: nil, currency: 'USD',
          customize_fields: nil
        }
        post "/v1/brands/#{brand.id}/products", params:, headers: { 'Authentication' => token }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body['message']).to including('Customize fields must be a valid JSON object')

        params = {
          name: 'product1', price: nil, currency: 'USD',
          customize_fields: 'string'
        }
        post "/v1/brands/#{brand.id}/products", params:, headers: { 'Authentication' => token }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body['message']).to including('Customize fields must be a valid JSON object')

        params = {
          name: 'product1', price: nil, currency: 'USD',
          customize_fields: Array.new(1,2)
        }
        post "/v1/brands/#{brand.id}/products", params:, headers: { 'Authentication' => token }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body['message']).to including('Customize fields must be a valid JSON object')
      end

      it 'cannot create the product with product.state the value is not a active or inactive' do
        params = {
          name: 'product1', price: 100.0, currency: 'USD', state: 'invalid',
          customize_fields: { custom1: 'value1', custom2: 'value2' }
        }
        post "/v1/brands/#{brand.id}/products", params:, headers: { 'Authentication' => token }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body['message']).to including('State is not included in the list')
      end
    end
  end

  describe 'PATCH /v1/brands/:brand_id/products/:id' do
    let!(:product) { create(:product, brand:) }

    context 'without user login' do
      it 'cannot access' do
        patch "/v1/brands/#{brand.id}/products/#{product.id}"
        expect(response).to have_http_status(:unauthorized)
        expect(response.parsed_body['message']).to eq 'Please login to continue'
      end
    end

    context 'with user login' do
      it 'update product success' do
        params = {
          name: 'update_name', price: 200.0, currency: 'EUR', state: 'inactive',
          customize_fields: { custom1: 'update_value1', update_custom2: 'value2' }
        }
        patch "/v1/brands/#{brand.id}/products/#{product.id}", params:, headers: { 'Authentication' => token }

        expect(response).to have_http_status(:success)
        updated_product = Product.find_by(name: 'update_name')

        expect(updated_product.name).to eq 'update_name'
        expect(updated_product.state).to eq 'inactive'
        expect(updated_product.price).to eq 200
        expect(updated_product.currency).to eq 'EUR'
        expect(updated_product.customize_fields).to eq({ 'custom1' => 'update_value1', 'update_custom2' => 'value2' })
      end

      it 'cannot access with invalid token' do
        params = {
          name: 'update_name', price: 200.0, currency: 'EUR', state: 'inactive',
          customize_fields: { custom1: 'update_value1', update_custom2: 'value2' }
        }
        patch "/v1/brands/#{brand.id}/products/#{product.id}", params:, headers: { 'Authentication' => 'invalid_token' }

        expect(response).to have_http_status(:unauthorized)
        expect(response.parsed_body['message']).to eq 'Please login to continue'
      end

      it 'cannot update the product with product.name is blank' do
        params = {
          name: '', price: 200.0, currency: 'EUR', state: 'inactive',
          customize_fields: { custom1: 'update_value1', update_custom2: 'value2' }
        }
        patch "/v1/brands/#{brand.id}/products/#{product.id}", params:, headers: { 'Authentication' => token }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body['message']).to including("Name can't be blank")
      end

      it 'cannot update the product with product.currency is blank' do
        params = {
          name: 'update_name', price: 200.0, currency: '', state: 'inactive',
          customize_fields: { custom1: 'update_value1', update_custom2: 'value2' }
        }
        patch "/v1/brands/#{brand.id}/products/#{product.id}", params:, headers: { 'Authentication' => token }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body['message']).to including("Currency can't be blank")
      end

      it 'cannot update the product with product.currency not included the list' do
        params = {
          name: 'update_name', price: 200.0, currency: 'AAA', state: 'inactive',
          customize_fields: { custom1: 'update_value1', update_custom2: 'value2' }
        }
        patch "/v1/brands/#{brand.id}/products/#{product.id}", params:, headers: { 'Authentication' => token }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body['message']).to including('Currency is not included in the list')
      end

      it 'cannot update the product with product.price is blank' do
        params = {
          name: 'update_name', price: nil, currency: 'EUR', state: 'inactive',
          customize_fields: { custom1: 'update_value1', update_custom2: 'value2' }
        }
        patch "/v1/brands/#{brand.id}/products/#{product.id}", params:, headers: { 'Authentication' => token }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body['message']).to including("Price can't be blank")
      end

      it 'cannot update the product with product.price is not numeric' do
        params = {
          name: 'update_name', price: '100,00', currency: 'EUR', state: 'inactive',
          customize_fields: { custom1: 'update_value1', update_custom2: 'value2' }
        }
        patch "/v1/brands/#{brand.id}/products/#{product.id}", params:, headers: { 'Authentication' => token }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body['message']).to including('Price is not a number')
      end

      it 'cannot update the product.customize_fields is not a JSON' do
        expect(product.customize_fields).to eq({})

        params = {
          name: 'update_name', price: 200, currency: 'EUR', state: 'inactive',
          customize_fields: nil
        }
        patch "/v1/brands/#{brand.id}/products/#{product.id}", params:, headers: { 'Authentication' => token }

        expect(response).to have_http_status(:success)
        expect(product.reload.customize_fields).to eq({})

        params = {
          name: 'update_name', price: 200, currency: 'EUR', state: 'inactive',
          customize_fields: 'string'
        }
        patch "/v1/brands/#{brand.id}/products/#{product.id}", params:, headers: { 'Authentication' => token }

        expect(response).to have_http_status(:success)
        expect(product.reload.customize_fields).to eq({})

        params = {
          name: 'update_name', price: 200, currency: 'EUR', state: 'inactive',
          customize_fields: Array.new(1, 2)
        }
        patch "/v1/brands/#{brand.id}/products/#{product.id}", params:, headers: { 'Authentication' => token }

        expect(response).to have_http_status(:success)
        expect(product.reload.customize_fields).to eq({})
      end

      it 'cannot update the product with product.state the value is not a active or inactive' do
        params = {
          name: 'update_name', price: 200, currency: 'EUR', state: 'invalid',
          customize_fields: { custom1: 'update_value1', update_custom2: 'value2' }
        }
        patch "/v1/brands/#{brand.id}/products/#{product.id}", params:, headers: { 'Authentication' => token }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body['message']).to including('State is not included in the list')
      end

      it 'cannot update with incorrect product.id' do
        params = {
          name: 'update_name', price: 200, currency: 'EUR', state: 'invalid',
          customize_fields: { custom1: 'update_value1', update_custom2: 'value2' }
        }
        patch "/v1/brands/#{brand.id}/products/incorrect_id", params:, headers: { 'Authentication' => token }

        expect(response).to have_http_status(:no_content)
      end
    end
  end

  describe 'DELETE /v1/brands/:brand_id/products/:id' do
    let!(:product) { create(:product, brand:) }

    context 'without user login' do
      it 'cannot access' do
        delete "/v1/brands/#{brand.id}/products/#{product.id}"
        expect(response).to have_http_status(:unauthorized)
        expect(response.parsed_body['message']).to eq 'Please login to continue'
      end
    end

    context 'with user login' do
      it 'delete product success' do
        delete "/v1/brands/#{brand.id}/products/#{product.id}", headers: { 'Authentication' => token }
        expect(response).to have_http_status(:success)
        expect(Product.find_by(id: product.id)).to be_nil
      end

      it 'cannot delete product with product.id incorrect' do
        delete "/v1/brands/#{brand.id}/products/incorrect_id", headers: { 'Authentication' => token }
        expect(response).to have_http_status(:no_content)
        expect(Product.find_by(id: product.id)).to be_truthy
      end
    end
  end

  describe 'PATCH v1/brands/:brand_id/products/:id/activate' do
    let!(:inactive_product) { create(:product, brand:, state: :inactive) }

    context 'without user login' do
      it 'cannot access' do
        patch "/v1/brands/#{brand.id}/products/#{inactive_product.id}/activate"
        expect(response).to have_http_status(:unauthorized)
        expect(response.parsed_body['message']).to eq 'Please login to continue'
      end
    end

    context 'with user login' do
      it 'activate the brand' do
        expect(inactive_product.inactive?).to be true

        patch "/v1/brands/#{brand.id}/products/#{inactive_product.id}/activate", headers: { 'Authentication' => token }
        expect(response).to have_http_status(:success)
        expect(response.parsed_body['message']).to eq 'Product was successfully activated.'

        expect(inactive_product.reload.inactive?).to be false
      end

      it 'cannot access with invalid token' do
        expect(inactive_product.inactive?).to be true

        patch "/v1/brands/#{brand.id}/products/#{inactive_product.id}/activate", headers: {
          'Authentication' => 'invalid_token'
        }
        expect(response).to have_http_status(:unauthorized)

        expect(inactive_product.reload.inactive?).to be true
      end
    end
  end

  describe 'PATCH v1/brands/:brand_id/products/:id/inactivate' do
    let!(:active_product) { create(:product, brand:, state: :active) }

    context 'without user login' do
      it 'cannot access' do
        patch "/v1/brands/#{brand.id}/products/#{active_product.id}/inactivate"
        expect(response).to have_http_status(:unauthorized)
        expect(response.parsed_body['message']).to eq 'Please login to continue'
      end
    end

    context 'with user login' do
      it 'activate the brand' do
        expect(active_product.active?).to be true

        patch "/v1/brands/#{brand.id}/products/#{active_product.id}/inactivate", headers: { 'Authentication' => token }
        expect(response).to have_http_status(:success)
        expect(response.parsed_body['message']).to eq 'Product was successfully inactivated.'

        expect(active_product.reload.active?).to be false
      end

      it 'cannot access with invalid token' do
        expect(active_product.active?).to be true

        patch "/v1/brands/#{brand.id}/products/#{active_product.id}/inactivate", headers: {
          'Authentication' => 'invalid_token'
        }

        expect(response).to have_http_status(:unauthorized)

        expect(active_product.reload.active?).to be true
      end
    end
  end
end
