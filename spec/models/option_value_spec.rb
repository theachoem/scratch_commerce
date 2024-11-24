require 'rails_helper'

RSpec.describe OptionValue, type: :model do
  subject { create(:option_value) }

  describe 'associations' do
    it { should belong_to(:option_type) }
    it { should have_many(:option_value_variants).order(:position) }
    it { should have_many(:variants).through(:option_value_variants) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive.scoped_to(:option_type_id) }
    it { should validate_presence_of(:presentation) }
  end

  describe 'callbacks' do
    let(:option_type) { create(:option_type, presentation: 'Color') }
    let(:option_value) { create(:option_value, presentation: 'Red', option_type: option_type) }
    let(:product) { create(:product, option_types: [ option_type ]) }
    let(:variant) { create(:variant, product: product, option_values: [ option_value ]) }

    it 'calls reload_variant_option_texts_cache after commit' do
      expect(variant.option_texts).to eq "Color: Red"
      expect(Rails.cache.fetch(variant.option_texts_cache_key)).to eq "Color: Red"

      expect(option_value).to receive(:reload_variant_option_texts_cache).and_call_original
      option_value.update!(presentation: 'Blue')

      expect(Rails.cache.fetch(variant.option_texts_cache_key)).to eq "Color: Blue"
      expect(variant.option_texts).to eq "Color: Blue"
    end
  end
end
