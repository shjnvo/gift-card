def user_login(email, password)
  post '/v1/login', params: { email:, password: }
  expect(response).to have_http_status(:success)

  response.parsed_body['token']
end
