require 'rails_helper'

RSpec.describe Product, type: :model do
  subject { create(:product) }

  describe 'associations' do
    it { should have_many(:variants).order(:position) }
    it { should have_many(:product_images).order(:position) }
    it { should have_many(:option_type_products).order(:position) }
    it { should have_many(:option_types).through(:option_type_products) }
    it { should have_many(:taxon_products).order(:position) }
    it { should have_many(:taxons).through(:taxon_products) }
    it { should have_many(:product_properties).order(:position) }
    it { should have_many(:properties).through(:product_properties) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:status) }
    it { should validate_uniqueness_of(:slug) }
  end

  describe 'callbacks' do
    let(:product) { create(:product, slug: 'Product 123') }

    it 'normalizes the slug before validation on update' do
      expect(product).to receive(:normalize_slug).and_call_original

      product.name = 'New Slug with Spaces'
      product.save!

      expect(product.slug).to eq('new-slug-with-spaces')
    end
  end
end
