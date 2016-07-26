require "rails_helper"

RSpec.describe Filter do

  let(:ruby_microscope) { create(:ruby_microscope) }
  let(:rails_tutorial) { create(:ruby_on_rails_tutorial) }
  let(:agile_web_dev) { create(:agile_web_development) }
  let(:books) { [ruby_microscope, rails_tutorial, agile_web_dev] }

  let(:scope) { Book.all }
  let(:params) { {} }
  let(:filter) { Filter.new(scope, params) }
  let(:filtered) { filter.filter }

  before do
    allow(BookPresenter).
        to(receive(:filter_attributes).
            and_return(['id','title','released_on']))
    books
  end

  describe '#filter' do
    context 'without any parameters' do

      it "returns the scope unchanged" do
        expect(filtered).to eq scope
      end
    end
  end
end