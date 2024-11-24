require 'rails_helper'

RSpec.describe User, type: :model do
  subject { create(:user) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  end

  describe 'associations' do
    it { should have_many(:sessions).dependent(:destroy) }
    it { should have_many(:merchant_users).dependent(:destroy) }
    it { should have_many(:merchants).through(:merchant_users) }
  end

  describe 'callbacks' do
    let(:user) { create(:user, email: ' Test@Email.com ') }

    it 'normalizes the email before saving' do
      expect(user.email).to eq('test@email.com')
    end
  end
end
