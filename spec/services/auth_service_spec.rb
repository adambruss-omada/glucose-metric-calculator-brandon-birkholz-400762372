require 'rails_helper'

RSpec.describe AuthService do
  let(:member) { create(:member) }
  let(:test_key) { 'test_secret_key_for_jwt_tokens' }

  before do
    ENV.delete('JWT_SECRET_KEY')
  end

  describe '.decode_token' do
    context 'with valid token' do
      it 'returns the member' do
        token = described_class.generate_token(member)
        expect(described_class.decode_token(token)).to eq(member)
      end
    end

    context 'with invalid token' do
      it 'returns nil' do
        expect(described_class.decode_token('invalid_token')).to be_nil
      end
    end

    context 'with token for non-existent member' do
      it 'returns nil' do
        token = JWT.encode({ member_id: -1 }, test_key, 'HS256')
        expect(described_class.decode_token(token)).to be_nil
      end
    end
  end
end
