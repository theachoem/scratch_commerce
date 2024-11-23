require 'rails_helper'

RSpec.describe Merchant, type: :model do
  subject { create(:merchant) }

  describe 'associations' do
    it { should have_many(:products) }
    it { should have_many(:merchant_users) }
    it { should have_many(:users).through(:merchant_users) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:commission_rate) }
    it { should validate_uniqueness_of(:slug) }

    context 'when commission_rate is less than 0' do
      it { should_not allow_value(-1).for(:commission_rate) }
    end

    context 'when commission_rate is greater than 100' do
      it { should_not allow_value(101).for(:commission_rate) }
    end
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
