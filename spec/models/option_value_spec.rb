require 'rails_helper'

RSpec.describe OptionValue, type: :model do
  describe 'associations' do
    it { should belong_to(:option_type) }
    it { should have_many(:option_value_variants).order(:position) }
    it { should have_many(:variants).through(:option_value_variants) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive }
    it { should validate_presence_of(:presentation) }
  end
end
