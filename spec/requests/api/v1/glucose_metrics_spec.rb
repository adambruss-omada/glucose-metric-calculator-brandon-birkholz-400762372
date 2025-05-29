require 'rails_helper'

RSpec.describe 'Api::V1::GlucoseMetrics', type: :request do
  let(:member) { create(:member) }
  let(:token) { AuthService.generate_token(member) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  describe 'GET /api/v1/glucose_metrics/:time_frame' do
    context 'with valid authentication' do
      context 'with weekly time frame' do
        before do
          create(:glucose_level, member: member, value: 150, tested_at: 1.day.ago)
          create(:glucose_level, member: member, value: 200, tested_at: 2.days.ago) # above range
          create(:glucose_level, member: member, value: 60, tested_at: 3.days.ago)  # below range
          create(:glucose_level, member: member, value: 140, tested_at: 4.days.ago)
        end

        it 'returns the correct metrics' do
          get '/api/v1/glucose_metrics/week', headers: headers

          expect(response).to have_http_status(:ok)
          json_response = JSON.parse(response.body)
          expect(json_response['average_glucose']).to eq(137.5)
          expect(json_response['time_above_range']).to eq(25.0)
          expect(json_response['time_below_range']).to eq(25.0)
        end
      end

      context 'with monthly time frame' do
        before do
          create(:glucose_level, member: member, value: 150, tested_at: Time.current.beginning_of_month + 1.day)
          create(:glucose_level, member: member, value: 200, tested_at: Time.current.beginning_of_month + 2.days) # above range
          create(:glucose_level, member: member, value: 60, tested_at: Time.current.beginning_of_month + 3.days)  # below range
          create(:glucose_level, member: member, value: 140, tested_at: Time.current.beginning_of_month + 4.days)
        end

        it 'returns the correct metrics' do
          get '/api/v1/glucose_metrics/month', headers: headers

          expect(response).to have_http_status(:ok)
          json_response = JSON.parse(response.body)
          expect(json_response['average_glucose']).to eq(137.5)
          expect(json_response['time_above_range']).to eq(25.0)
          expect(json_response['time_below_range']).to eq(25.0)
        end
      end

      context 'with invalid time frame' do
        it 'returns a bad request error' do
          get '/api/v1/glucose_metrics/invalid', headers: headers

          expect(response).to have_http_status(:bad_request)
          json_response = JSON.parse(response.body)
          expect(json_response['error']).to eq('Invalid time frame. Must be either "week" or "month"')
        end
      end
    end

    context 'without authentication' do
      it 'returns an unauthorized error' do
        get '/api/v1/glucose_metrics/week'

        expect(response).to have_http_status(:unauthorized)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('Unauthorized')
      end
    end

    context 'with invalid token' do
      it 'returns an unauthorized error' do
        get '/api/v1/glucose_metrics/week', headers: { 'Authorization' => 'Bearer invalid_token' }

        expect(response).to have_http_status(:unauthorized)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('Invalid token')
      end
    end
  end
end
