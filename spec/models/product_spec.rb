require 'rails_helper'

RSpec.describe Product, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:status) }
  it { should validate_presence_of(:slug) }
  it { should validate_uniqueness_of(:slug) }

  it { should have_many(:variants).order(:position) }
  it { should have_many(:option_type_products).order(:position) }
  it { should have_many(:option_types).through(:option_type_products) }
  it { should have_many(:taxon_products).order(:position) }
  it { should have_many(:taxons).through(:taxon_products) }
  it { should have_many(:product_properties).order(:position) }
  it { should have_many(:properties).through(:product_properties) }
end
