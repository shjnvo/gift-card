def get_token(email, password)
  post '/v1/login', params: { email:, password: }
  response.parsed_body['token']
end
