RSpec.describe User, type: :model do 
  context 'associations' do
    context 'has many' do
      it { is_expected.to have_many(:projects).dependent(:destroy) }
    end
  end

  context 'validation' do
    context 'presence' do
      it { is_expected.to validate_presence_of(:username) }
      it { is_expected.to validate_presence_of(:password) }
    end

    context 'length' do
      it { is_expected.to validate_length_of(:username).is_at_least(3).is_at_most(50) }
      it { is_expected.to validate_length_of(:password).is_equal_to(8) }
    end

    context 'confirmation' do
      it { is_expected.to validate_confirmation_of(:password) }
    end

    context 'uniqueness' do
      it { is_expected.to validate_uniqueness_of(:username).case_insensitive }
    end

    context 'format' do
      it { is_expected.to allow_value('Ad1231dh').for(:password) }
      it { is_expected.not_to allow_value('Aa1-Aa1b').for(:password) }
    end
  end
end
