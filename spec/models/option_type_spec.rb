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
end
