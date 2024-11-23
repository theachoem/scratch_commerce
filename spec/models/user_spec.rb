require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:merchant_users) }
    it { should have_many(:merchants).through(:merchant_users) }
  end
end
