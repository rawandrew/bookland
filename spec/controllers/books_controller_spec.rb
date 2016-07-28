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

      context 'without the "fields" parameter' do
        before { get :index }

        it 'gets books with all the fields specified in the presenter' do
          json_body['data'].each do |book|
            expect(book.keys).to eq BookPresenter.build_attributes.map(&:to_s)
          end
        end
      end

      context 'with invalid field name "fid"' do
        before { get :index, params: { fields: 'fid,title,author_id' } }

        it 'gets `400 Bad Request` back' do
          expect(response.status).to eq 400
        end

        it 'receives an error' do
          expect(json_body['error']).to_not be nil
        end

        it 'receives "fields=fid" as an invalid param' do
          expect(json_body['error']['invalid_params']).to eq 'fields=fid'
        end
      end
    end

    describe 'embed picking' do
      context 'with the "embed" parameter' do
        before { get :index, params: { embed: 'author'} }

        it 'gets the books with their authors embedded' do
          json_body['data'].each do |book|
            expect(book['author'].keys).to eq(['id', 'given_name', 'family_name', 'created_at', 'updated_at'])
          end
        end
      end

      context 'with invalid "embed" relation "fake"' do
        before { get :index, params: { embed: 'fake,author'} }

        it 'gets `400 Bad Request` back' do
          expect(response.status).to eq 400
        end

        it 'receives an error' do
          expect(json_body['error']).to_not be nil
        end

        it 'receives "fields=fid" as an invalid param' do
          expect(json_body['error']['invalid_params']).to eq 'embed=fake'
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

    describe 'sorting' do
      context 'with valid column name "id"' do

        it 'sorts the books by "id desc"' do
          get :index, params: {sort: 'id', dir: 'desc'}

          expect(json_body['data'].first['id']).to eq agile_web_development.id
          expect(json_body['data'].last['id']).to eq ruby_microscope.id
        end
      end

      context 'with invalid column name "fid"' do
        before { get :index, params: {sort: 'fid', dir: 'asc'} }

        it 'gets `400 Bad Request` back' do
          expect(response.status).to eq 400
        end

        it 'receives an error' do
          expect(json_body['error']).to_not be nil
        end

        it 'receives "sort=fid" as an invalid param' do
          expect(json_body['error']['invalid_params']).to eq 'sort=fid'
        end
      end
    end

    describe 'filtering' do

      context 'with valid filtering param "q[title_cont]=Microscope"' do

        it 'receives "Ruby under a microscope" back' do
          get :index, params: { 'q[title_cont]' => 'Microscope' }
          expect(json_body['data'].first['id']).to eq ruby_microscope.id
          expect(json_body['data'].size).to eq 1
        end
      end

      context 'with invalid filtering param "q[ftitle_cont]=Microscope"' do
        before { get :index, params: { 'q[ftitle_cont]' => 'Microscope' } }

        it 'gets `400 Bad Request` back' do
          expect(response.status).to eq 400
        end

        it 'receives an error' do
          expect(json_body['error']).to_not be nil
        end

        it 'receives "q[ftitle_cont]=Ruby" as an invalid param' do
          expect(json_body['error']['invalid_params']).to eq 'q[ftitle_cont]=Microscope'
        end
      end
    end
  end

  describe 'GET /api/books/:id' do
    context 'with existing resource' do
      before { get :show, params: { id: ruby_on_rails_tutorial.id } }

      it 'gets HTTP status 200' do
        expect(response.status).to eq 200
      end

      it 'receives the "rails_tutorial" book as JSON' do
        expected = { data: BookPresenter.new(ruby_on_rails_tutorial, {}).fields.embeds }
        expect(response.body).to eq(expected.to_json)
      end
    end

    context 'with nonexistent resource' do

      it 'gets HTTP status 404' do
        get :show, params: { id: 232521442 }
        expect(response.status).to eq 404
      end
    end
  end
end