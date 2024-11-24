require 'rails_helper'

RSpec.describe Address, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:address1) }
  end

  describe '#split_full_name' do
    subject { build(:address) }

    context 'when full_name is not provided' do
      it 'does not call split_full_name' do
        expect(subject).not_to receive(:split_full_name).and_call_original

        subject.full_name = nil
        subject.validate
      end
    end

    context 'when full_name is provided with single word' do
      it 'does not change first_name or last_name' do
        expect(subject).to receive(:split_full_name).and_call_original

        subject.full_name = "Sahakom"
        subject.validate

        expect(subject.first_name).to eq "Sahakom"
        expect(subject.last_name).to be_nil
      end
    end

    context 'when full_name is provided with 2 words' do
      it 'splits the full_name into first_name and last_name' do
        expect(subject).to receive(:split_full_name).and_call_original

        subject.full_name = "John Doe"
        subject.validate

        expect(subject.first_name).to eq("John")
        expect(subject.last_name).to eq("Doe")
      end
    end

    context 'when full_name is provided with 3+ words' do
      it 'splits the full_name into first_name and last_name' do
        expect(subject).to receive(:split_full_name).and_call_original

        subject.full_name = "John Doe Man Jack"
        subject.validate

        expect(subject.first_name).to eq("John")
        expect(subject.last_name).to eq("Doe Man Jack")
      end
    end
  end

  describe '#sanitize_phone_number' do
    before { Phonelib.default_country = "KH" }

    context 'when phone_number is not blank' do
      subject { build(:address, phone_number: '12345678') }
      it 'sanitizes the phone_number' do
        subject.validate
        expect(subject.phone_number).to eq '012345678'
        expect(subject.phone_number_intl).to eq '+85512345678'
        expect(subject.country_code).to eq 'KH'
      end
    end

    context 'when phone_number is blank' do
      subject { build(:address, phone_number: nil) }
      it 'does not modify phone_number or country_code' do
        expect(subject).not_to receive(:sanitize_phone_number)
        subject.validate
      end
    end
  end

  describe '#sanitize_alt_phone_number' do
    before { Phonelib.default_country = "KH" }

    context 'when alt_phone_number is not blank' do
      subject { build(:address, alt_phone_number: '12345678') }
      it 'sanitizes the alt_phone_number' do
        subject.validate
        expect(subject.alt_phone_number).to eq '012345678'
        expect(subject.alt_phone_number_intl).to eq '+85512345678'
        expect(subject.country_code).to eq 'KH'
      end
    end

    context 'when alt_phone_number is blank' do
      subject { build(:address, alt_phone_number: nil) }
      it 'does not modify alt_phone_number or country_code' do
        expect(subject).not_to receive(:sanitize_alt_phone_number)
        subject.validate
      end
    end
  end
end
