# frozen_string_literal: true

RSpec.describe Project do
  describe 'associations' do
    describe 'belongs to' do
      it { is_expected.to belong_to(:user) }
    end

    describe 'has many' do
      it { is_expected.to have_many(:tasks).dependent(:destroy) }
    end
  end

  describe 'validations' do
    describe 'presence' do
      it { is_expected.to validate_presence_of(:name) }
    end

    describe 'uniqueness' do
      it { is_expected.to validate_uniqueness_of(:name).scoped_to(:user_id) }
    end
  end
end
