require 'rails_helper'

RSpec.describe Paginator do

  let(:ruby_microscope) { create(:ruby_microscope) }
  let(:rails_tutorial) { create(:ruby_on_rails_tutorial) }
  let(:agile_web_dev) { create(:agile_web_development) }
  let(:books) { [ruby_microscope, rails_tutorial, agile_web_dev] }

  let(:scope) { Book.all }
  let(:params) { { 'page' => '1', 'per' => '2' } }
  let(:paginator) { Paginator.new(scope, params, 'url') }
  let(:paginated) { paginator.paginate }

  before do
    books
  end

  describe '#paginate' do
    it 'paginates the collection with 2 books' do
      expect(paginated.size).to eq 2
    end
    it 'contains ruby_microscope as the first paginated item' do
      expect(paginated.first).to eq ruby_microscope
    end
    it 'contains rails_tutorial as the last paginated item' do
      expect(paginated.last).to eq rails_tutorial
    end
  end
end