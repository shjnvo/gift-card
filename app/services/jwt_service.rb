class JwtService
  HMAC_SECRET = Rails.application.credentials.secret_key_base
  HASH_ALGORITHM = 'HS256'.freeze
  EXPIRATION = 24.hours

  class << self
    def encode(payload)
      payload[:exp] ||= EXPIRATION.from_now.to_i
      JWT.encode(payload, HMAC_SECRET, HASH_ALGORITHM)
    end

    def decode(token)
      JWT.decode(token, HMAC_SECRET, true, { algorithm: 'HS256' }).first
    rescue JWT::DecodeError => e
      Rails.logger.error e.message
      {}
    end
  end
end
