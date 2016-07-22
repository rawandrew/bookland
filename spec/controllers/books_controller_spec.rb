require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  describe 'GET /api/books' do
    it 'receives HTTP status 200' do
      get :index
      expect(response.status).to eq 200
    end
  end
end