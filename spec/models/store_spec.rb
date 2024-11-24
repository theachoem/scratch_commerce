require 'rails_helper'

RSpec.describe Store, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:orders) }
  end

  describe 'validations' do
    it { is_expected.to allow_value('http://example.com').for(:url) }
    it { is_expected.to allow_value('https://example.com').for(:url) }
    it { is_expected.not_to allow_value('ftp://example.com').for(:url) }
    it { is_expected.not_to allow_value('invalid_url').for(:url) }
  end

  describe 'callbacks' do
    let!(:store) { create(:store, is_default: true) }

    context 'after_commit' do
      it 'clears the default store cache' do
        expect(Rails.cache).to receive(:delete).with('store_default')
        store.save!
      end
    end

    context 'before_save' do
      it 'ensures there is one default store and it is unique' do
        new_store = create(:store)
        new_store.update!(is_default: true)
        expect(Store.where(is_default: true).count).to eq(1)
        expect(store.reload.is_default).to be_falsey
      end

      it 'sets a store as default if no default store exists' do
        store.update!(is_default: false)
        new_store = create(:store)
        new_store.save!
        expect(new_store.is_default).to be_truthy
      end
    end

    context 'before_destroy' do
      it 'prevents destroying the default store' do
        expect(store.destroy).to be_falsey
      end

      it 'allows destroying a non-default store' do
        store.update!(is_default: false)
        expect { store.destroy }.to change { Store.count }.by(-1)
      end
    end
  end

  describe '.default' do
    let!(:default_store) { create(:store, is_default: true) }

    it 'fetches the default store from the cache' do
      Store.default

      expect(Rails.cache).to receive(:fetch).with('store_default').and_call_original
      expect(Rails.cache.fetch('store_default')).to eq default_store
    end

    it 'returns nil if no default store exists' do
      default_store.update!(is_default: false)

      Rails.cache.delete('store_default')
      expect(Store.default).to be_nil
    end
  end

  describe '#default?' do
    let!(:default_store) { create(:store, is_default: true) }

    it { expect(create(:store, is_default: true).default?).to be_truthy }
    it { expect(create(:store, is_default: false).default?).to be_falsey }
  end
end
