require 'rails_helper'

RSpec.describe Order, type: :model do
  let!(:default_store) { create(:store, is_default: true) }

  subject { create(:order, store: default_store) }

  describe 'validations' do
    before { allow(subject).to receive(:email_required?).and_return(true) }

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:guest_token) }
    it { is_expected.to validate_presence_of(:number) }
    it { is_expected.to validate_uniqueness_of(:number) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user).optional }
    it { is_expected.to have_many(:line_items).dependent(:destroy) }
    it { is_expected.to have_many(:shipments).dependent(:destroy) }
    it { is_expected.to have_many(:adjustments).order(:created_at).dependent(:destroy) }
    it { is_expected.to have_many(:line_item_adjustments).through(:line_items).source(:adjustments) }
    it { is_expected.to have_many(:shipment_adjustments).through(:shipments).source(:adjustments) }
    it { is_expected.to have_many(:all_adjustments).dependent(:destroy) }
    it { is_expected.to belong_to(:billing_address).class_name(Address.name).optional }
    it { is_expected.to belong_to(:shipping_address).class_name(Address.name).optional }
    it { is_expected.to belong_to(:approver).class_name(User.name).optional }
    it { is_expected.to belong_to(:canceler).class_name(User.name).optional }
  end

  describe 'callbacks' do
    let(:store) { create(:store, default_currency: '៛', is_default: false) }
    subject { build(:order, store: nil) }

    context 'before_validation' do
      describe '#associate_default_store' do
        it 'associate_default_store when store_id is blank' do
          expect(subject).to receive(:associate_default_store).and_call_original
          subject.validate
          expect(subject.store).to eq default_store
        end

        it 'does not call associate_default_store when store_id is present' do
          subject = build(:order, store: store)
          expect(subject).not_to receive(:associate_default_store)
          subject.validate
          expect(subject.store).to eq store
        end
      end

      describe '#set_currency' do
        it 'set_currency base on store default currency when currency is blank' do
          subject = build(:order, store: store, currency: nil)
          expect(subject).to receive(:set_currency).and_call_original
          subject.validate
          expect(subject.currency).to eq '៛'
        end

        it 'does not call set_currency when currency is already present?' do
          subject = build(:order, store: store, currency: 'USD')
          expect(subject).not_to receive(:set_currency).and_call_original
          subject.validate
          expect(subject.currency).to eq 'USD'
        end
      end

      describe '#generate_order_number' do
        it 'generates a valid order number' do
          order = build(:order)
          expect(order.number).to be_nil
          order.validate

          expect(order.number).to start_with("R")
          expect(order.number.length).to eq(9)
        end
      end

      describe '#create_token' do
        it 'generates a unique guest_token' do
          allow(SecureRandom).to receive(:urlsafe_base64).and_return('random_token')
          order = build(:order, guest_token: nil)
          order.validate
          expect(order.guest_token).to eq('random_token')
        end
      end

      describe '#link_by_email' do
        let(:user) { create(:user, email: 'test@sahakom.com') }

        it 'link email from user when user is present' do
          order = build(:order, user: user, email: nil)
          order.validate
          expect(order.email).to eq(user.email)
        end
      end
    end
  end
end
