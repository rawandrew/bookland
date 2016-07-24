require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  let(:ruby_microscope) { create(:ruby_microscope) }
  let(:ruby_on_rails_tutorial) { create(:ruby_on_rails_tutorial) }
  let(:agile_web_development) { create(:agile_web_development) }

  let(:books) { [ruby_microscope, ruby_on_rails_tutorial, agile_web_development] }

  let(:json_body) { JSON.parse(response.body) }

  describe 'GET /api/books' do
    before { books }

    context 'default behavior' do
      before { get :index }

      it 'receives HTTP status 200' do
        expect(response.status).to eq 200
      end

      it 'receives a json with the "data" root key' do
        expect(json_body['data']).to_not be nil
      end

      it 'receives all 3 books' do
        expect(json_body['data'].size).to eq 3
      end
    end
  end
end