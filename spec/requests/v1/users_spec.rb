require 'rails_helper'

RSpec.describe 'V1::Users' do
  describe 'POST /v1/users' do
    it 'register user success' do
      post '/v1/users', params: { email: 'test_user@example.com', password: '123password$' }
      expect(response).to have_http_status(:success)
      expect(response.parsed_body['email']).to eq 'test_user@example.com'
      expect(User.count).to eq 1
      expect(User.first.email).to eq 'test_user@example.com'
      expect(User.first.authenticate('123password$')).to be_truthy
    end

    context 'when register user fails' do
      it 'without password' do
        post '/v1/users', params: { email: 'test_user@example.com' }
        expect(response).to have_http_status(422)
        expect(response.parsed_body['message']).to including("Password can't be blank")
        expect(response.parsed_body['message']).to including('Password is too short (minimum is 8 characters)')
      end

      it 'wrong email format' do
        post '/v1/users', params: { email: 'test_userexample', password: '123password$' }
        expect(response).to have_http_status(422)
        expect(response.parsed_body['message']).to including('Email is invalid')

        post '/v1/users', params: { email: 'test_user@@example.com', password: '123password$' }
        expect(response).to have_http_status(422)
        expect(response.parsed_body['message']).to including('Email is invalid')
      end
    end
  end
end
