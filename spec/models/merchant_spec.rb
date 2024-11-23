require 'rails_helper'

RSpec.describe Merchant, type: :model do
  subject { create(:merchant) }

  describe 'associations' do
    it { should have_many(:products) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:status) }
    it { should validate_uniqueness_of(:slug) }
  end

  describe 'callbacks' do
    let(:merchant) { create(:merchant, slug: 'Merchant 123') }

    it 'normalizes the slug before validation on update' do
      expect(merchant).to receive(:normalize_slug).and_call_original

      merchant.name = 'New Slug with Spaces'
      merchant.save!

      expect(merchant.slug).to eq('new-slug-with-spaces')
    end
  end
end
