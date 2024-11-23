require 'rails_helper'

RSpec.describe ProductProperty, type: :model do
  let(:property) { create(:property, attr_type: :integer) }
  let(:product) { create(:product) }

  subject { create(:product_property, property: property, value: 1) }

  describe 'associations' do
    it { should belong_to(:product).required }
    it { should belong_to(:property).required }
  end

  describe 'validations' do
    context 'when value is present' do
      it { should validate_presence_of(:value) }
    end

    context 'when property type is integer' do
      let(:property) { create(:property, attr_type: :integer) }
      it { should validate_numericality_of(:value).only_integer }
    end

    context 'when property type is float' do
      let(:property) { create(:property, attr_type: :float) }
      it { should validate_numericality_of(:value) }
    end

    context 'when property type is boolean' do
      let(:property) { create(:property, attr_type: :string) }
      it { should_not validate_numericality_of(:value) }
    end

    context 'when property type is boolean' do
      let(:property) { create(:property, attr_type: :boolean) }
      it { should validate_inclusion_of(:value).in_array([ '1', '0' ]) }
    end
  end

  describe 'custom methods' do
    it 'defines the attr_type methods dynamically' do
      expect(subject.respond_to?(:attr_type_integer?)).to be(true)
      expect(subject.respond_to?(:attr_type_float?)).to be(true)
      expect(subject.respond_to?(:attr_type_boolean?)).to be(true)
    end
  end
end
