require 'rails_helper'
require 'devise/jwt/test_helpers'

RSpec.describe 'Api::V1::Bookings', type: :request do
  describe 'GET /bookings' do
    let(:user) { create(:user) }

    before do
      create_list(:booking, 10, user:)
      headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
      auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
      get '/api/v1/bookings', headers: auth_headers
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'returns 10 bookings' do
      expect(JSON.parse(response.body)['data'].count).to eq(10)
    end
  end

  describe 'GET /bookings/:id' do
    let(:user)    { create(:user) }
    let(:booking) { create(:booking, user:) }

    before do
      headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
      auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
      get "/api/v1/bookings/#{booking.id}", headers: auth_headers
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'returns the correct booking' do
      expect(JSON.parse(response.body)['data']['id']).to eq(booking.id)
    end
  end

  describe 'POST /bookings' do
    let(:user) { create(:user) }
    let(:bike) { create(:bike) }

    before do
      headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
      auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
      post "/api/v1/bikes/#{bike.id}/bookings", params: { 'booking': {
        'start_date': '11-06-2023',
        'end_date': '15-06-2023',
        'status': 'pending'
      } }.to_json,
                            headers: auth_headers
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'returns the correct booking' do
      expect(JSON.parse(response.body)['data']['bike']['id']).to eq(bike.id)
      expect(JSON.parse(response.body)['data']['user']['id']).to eq(user.id)
    end
  end

  describe 'PATCH /bookings/:id' do
    let(:user) { create(:user) }
    let(:booking) { create(:booking, user:) }

    before do
      headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
      auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
      patch "/api/v1/bookings/#{booking.id}", params: { 'booking': { 'status': 'accepted' } }.to_json, headers: auth_headers
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'returns the correct updated booking' do
      expect(JSON.parse(response.body)['data']['status']).to eq('accepted')
    end
  end

  describe 'DELETE /bookings/:id' do
    let(:user) { create(:user) }
    let(:booking) { create(:booking, user:) }

    before do
      headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
      auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
      delete "/api/v1/bookings/#{booking.id}", headers: auth_headers
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'returns the correct bike' do
      expect(JSON.parse(response.body)['data']['id']).to eq(booking.id)
    end
  end
end
