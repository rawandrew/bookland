require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  let(:ruby_microscope) { create(:ruby_microscope) }
  let(:ruby_on_rails_tutorial) { create(:ruby_on_rails_tutorial) }
  let(:agile_web_development) { create(:agile_web_development) }

  let(:books) { [ruby_microscope, ruby_on_rails_tutorial, agile_web_development] }

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

    describe 'field picking' do

      context 'with the fields parameter' do
        before { get :index, params: { fields: 'id,title,author_id' } }

        it 'gets books with only the id, title and author_id keys' do
          json_body['data'].each do |book|
            expect(book.keys).to eq ['id', 'title', 'author_id']
          end
        end
      end

      context "without the 'fields' parameter" do
        before { get :index }

        it 'gets books with all the fields specified in the presenter' do
          json_body['data'].each do |book|
            expect(book.keys).to eq BookPresenter.build_attributes.map(&:to_s)
          end
        end
      end
    end

    describe 'pagination' do

      context 'when asking for the first page' do
        before { get :index, params: { page: 1, per: 2 } }

        it 'receives HTTP status 200' do
          expect(response.status).to eq 200
        end

        it 'receives only two books' do
          expect(json_body['data'].size).to eq 2
        end

        it 'receives a response with the Link header' do
          expect(response.headers['Link'].split(', ').first)
              .to eq('<http://test.host/api/books?page=2&per=2>; rel="next"')
        end
      end

      context 'when asking for the second page' do
        before { get :index, params: { page: 2, per: 2 } }

        it 'receives HTTP status 200' do
          expect(response.status).to eq 200
        end

        it 'receives only one book' do
          expect(json_body['data'].size).to eq 1
        end
      end

      context 'when sending invalid "page" and "per" parameters' do
        before { get :index, params: { page: 'fake', per: 2 } }

        it 'receives HTTP status 400' do
          expect(response.status).to eq 400
        end

        it 'receives an error' do
          expect(json_body['error']).to_not be nil
        end

        it 'receives "page=fake" as an invalid param' do
          expect(json_body['error']['invalid_params']).to eq 'page=fake'
        end
      end
    end
  end
end