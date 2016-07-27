require 'rails_helper'

RSpec.describe Paginator do

  let(:ruby_microscope) { create(:ruby_microscope) }
  let(:rails_tutorial) { create(:ruby_on_rails_tutorial) }
  let(:agile_web_dev) { create(:agile_web_development) }
  let(:books) { [ruby_microscope, rails_tutorial, agile_web_dev] }

  let(:scope) { Book.all }
  let(:params) { { 'embed' => 'authors', 'include' => 'publishers' } }
  let(:eager_loader) { EagerLoader.new(scope, params) }
  let(:eager_loaded) { eager_loader.load }

  before do
    books
  end

  describe '#load' do
    it 'embeds the authors' do

    end
  end
end