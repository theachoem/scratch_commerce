require 'rails_helper'

RSpec.describe Property, type: :model do
  subject { create(:property) }

  describe 'associations' do
    it { should have_many(:product_properties) }
    it { should have_many(:products).through(:product_properties) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive }
    it { should validate_presence_of(:presentation) }
  end

  describe 'enum' do
    it { should define_enum_for(:attr_type).with_values(string: 0, integer: 1, float: 2, boolean: 3).with_prefix }
  end
end
