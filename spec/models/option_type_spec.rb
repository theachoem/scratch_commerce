require 'rails_helper'

RSpec.describe OptionType, type: :model do
  describe 'associations' do
    it { should have_many(:option_type_products) }
    it { should have_many(:products).through(:option_type_products) }
    it { should have_many(:option_values) }
    it { should have_many(:variants).through(:option_values) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive }
    it { should validate_presence_of(:presentation) }
  end

  describe 'callbacks' do
    let(:option_type) { create(:option_type, presentation: 'Color') }
    let(:option_value) { create(:option_value, presentation: 'Red', option_type: option_type) }
    let(:product) { create(:product, option_types: [ option_type ]) }
    let(:variant) { create(:variant, product: product, option_values: [ option_value ]) }

    it 'calls clear_variant_option_texts_cache after save' do
      expect(variant.option_texts).to eq "Color: Red"
      expect(Rails.cache.fetch(variant.option_texts_cache_key)).to eq "Color: Red"

      expect(option_type).to receive(:clear_variant_option_texts_cache).and_call_original
      option_type.update!(presentation: 'Colors')

      expect(Rails.cache.fetch(variant.option_texts_cache_key)).to eq nil
      expect(variant.option_texts).to eq "Colors: Red"
    end
  end
end
