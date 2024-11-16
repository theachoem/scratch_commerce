require 'rails_helper'

RSpec.describe Taxon, type: :model do
  describe 'callbacks' do
    let(:taxonomy) { create(:taxonomy, name: 'Category') }
    let(:parent) { create(:taxon, name: 'Electronic', taxonomy: taxonomy) }
    let(:child) { create(:taxon, name: 'Smart Phone', parent: parent, taxonomy: nil) }
    let(:children) { create(:taxon, name: 'Apple', parent: child, taxonomy: nil) }

    it 'set_permalink before save' do
      expect(child.permalink).to eq "electronic/smart-phone"
    end

    it 'update all children permalink after permalink save' do
      expect(children.permalink).to eq "electronic/smart-phone/apple"
      child.update(name: 'Smarter Phone')
      expect(children.permalink).to eq "electronic/smarter-phone/apple"
    end
  end
end
