require 'rails_helper'

RSpec.describe Authentication, type: :request do

  describe 'Client Authentication' do

    before { get '/api/books', headers: headers }
    context 'with invalid authentication scheme' do
      let(:headers) { { 'HTTP_AUTHORIZATION' => '' } }

      it 'gets HTTP status 401 Unauthorized' do
        expect(response.status).to eq 401
      end
    end

    context 'with valid authentication scheme' do
      let(:headers) do
        { 'HTTP_AUTHORIZATION' => "Bookland-Token api_key=#{key}" }
      end

      context 'with invalid API Key' do
        let(:key) { 'fake' }

        it 'gets HTTP status 401 Unauthorized' do
          expect(response.status).to eq 401
        end
      end

      context 'with disabled API Key' do
        let(:key) { ApiKey.create.tap { |key| key.disable }.key }

        it 'gets HTTP status 401 Unauthorized' do
          expect(response.status).to eq 401
        end
      end

      context 'with valid API Key' do
        let(:key) { ApiKey.create.key }

        it 'gets HTTP status 200' do
          expect(response.status).to eq 200
        end
      end
    end
  end
end