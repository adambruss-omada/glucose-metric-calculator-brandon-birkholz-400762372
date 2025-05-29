class AuthService
  class << self
    def generate_token(member)
      payload = { member_id: member.id }
      JWT.encode(payload, jwt_secret_key, 'HS256')
    end

    def decode_token(token)
      decoded = JWT.decode(token, jwt_secret_key, true, algorithm: 'HS256')
      member_id = decoded.first['member_id']
      Member.find(member_id)
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      nil
    end

    private

    def jwt_secret_key
      ENV.fetch('JWT_SECRET_KEY', 'test_secret_key_for_jwt_tokens')
    end
  end
end
